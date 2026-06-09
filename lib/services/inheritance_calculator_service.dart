/// Calcul approximatif de répartition successorale (farāʾiḍ) — école sunnite majoritaire.
/// Les cas complexes (hajb, 'awl, uterine siblings, etc.) nécessitent un savant.
class InheritanceInput {
  final double netEstate;
  final double wasiyyah;
  final bool hasHusband;
  final int wives;
  final int sons;
  final int daughters;
  final bool fatherAlive;
  final bool motherAlive;
  final int fullBrothers;
  final int fullSisters;

  const InheritanceInput({
    required this.netEstate,
    this.wasiyyah = 0,
    this.hasHusband = false,
    this.wives = 0,
    this.sons = 0,
    this.daughters = 0,
    this.fatherAlive = false,
    this.motherAlive = false,
    this.fullBrothers = 0,
    this.fullSisters = 0,
  });

  bool get hasOffspring => sons > 0 || daughters > 0;
  int get siblingCount => fullBrothers + fullSisters;
  bool get hasSpouse => hasHusband || wives > 0;
}

class HeirAllocation {
  final String heirId;
  final int count;
  final double shareFraction;
  final double amount;

  const HeirAllocation({
    required this.heirId,
    this.count = 1,
    required this.shareFraction,
    required this.amount,
  });

  double get perPersonAmount => count > 0 ? amount / count : amount;
}

class InheritanceResult {
  final double grossEstate;
  final double wasiyyahDeducted;
  final double distributable;
  final List<HeirAllocation> allocations;
  final bool awlApplied;
  final bool raddApplied;
  final List<String> notes;

  const InheritanceResult({
    required this.grossEstate,
    required this.wasiyyahDeducted,
    required this.distributable,
    required this.allocations,
    this.awlApplied = false,
    this.raddApplied = false,
    this.notes = const [],
  });
}

class InheritanceCalculatorService {
  static InheritanceResult? calculate(InheritanceInput input) {
    if (input.netEstate <= 0) return null;
    if (input.hasHusband && input.wives > 0) return null;

    final maxWasiyyah = input.netEstate / 3;
    final wasiyyah = input.wasiyyah.clamp(0, maxWasiyyah).toDouble();
    final distributable = input.netEstate - wasiyyah;
    if (distributable <= 0) return null;

    final notes = <String>[];
    if (input.wasiyyah > maxWasiyyah) {
      notes.add('wasiyyah_capped');
    }

    final slots = <_Slot>[];

    if (input.hasHusband) {
      slots.add(_Slot('husband', input.hasOffspring ? 1 / 4 : 1 / 2));
    } else if (input.wives > 0) {
      final total = input.hasOffspring ? 1 / 8 : 1 / 4;
      slots.add(_Slot('wife', total, count: input.wives));
    }

    if (input.sons == 0 && input.daughters > 0) {
      final f = input.daughters == 1 ? 0.5 : 2 / 3;
      slots.add(_Slot('daughter', f, count: input.daughters));
    }

    if (input.fatherAlive && input.hasOffspring) {
      slots.add(_Slot('father', 1 / 6));
    }

    if (input.motherAlive) {
      final f = (input.hasOffspring || input.siblingCount >= 2) ? 1 / 6 : 1 / 3;
      slots.add(_Slot('mother', f));
    }

    final sistersAsFixed = input.sons == 0 &&
        input.daughters == 0 &&
        !input.fatherAlive &&
        input.fullBrothers == 0 &&
        input.fullSisters > 0;
    if (sistersAsFixed) {
      final f = input.fullSisters == 1 ? 0.5 : 2 / 3;
      slots.add(_Slot('full_sister', f, count: input.fullSisters));
    }

    var fixedSum = slots.fold<double>(0, (s, e) => s + e.fraction);
    var awlApplied = false;
    if (fixedSum > 1.0001) {
      awlApplied = true;
      notes.add('awl_applied');
      for (final s in slots) {
        s.fraction /= fixedSum;
      }
      fixedSum = 1;
    }

    var residue = 1 - fixedSum;
    var raddApplied = false;

    if (residue > 0.0001) {
      if (input.sons > 0) {
        final units = input.sons * 2 + input.daughters;
        final sonShare = (2 / units) * residue;
        final daughterShare = input.daughters > 0 ? (1 / units) * residue : 0;
        slots.add(_Slot('son', (sonShare * input.sons).toDouble(), count: input.sons));
        if (input.daughters > 0) {
          slots.add(_Slot('daughter', (daughterShare * input.daughters).toDouble(), count: input.daughters));
        }
        residue = 0;
      } else if (input.fatherAlive && !input.hasOffspring) {
        slots.add(_Slot('father', residue));
        residue = 0;
      } else if (input.fullBrothers > 0) {
        final units = input.fullBrothers * 2 + input.fullSisters;
        final broShare = (2 / units) * residue;
        final sisShare = input.fullSisters > 0 ? (1 / units) * residue : 0;
        slots.add(_Slot('full_brother', (broShare * input.fullBrothers).toDouble(), count: input.fullBrothers));
        if (input.fullSisters > 0) {
          slots.add(_Slot('full_sister', (sisShare * input.fullSisters).toDouble(), count: input.fullSisters));
        }
        residue = 0;
      } else if (residue > 0.0001 && slots.isNotEmpty) {
        raddApplied = true;
        notes.add('radd_applied');
        final eligible = slots.where((s) => s.heirId != 'husband' && s.heirId != 'wife').toList();
        final pool = eligible.isEmpty ? slots : eligible;
        final poolSum = pool.fold<double>(0, (s, e) => s + e.fraction);
        if (poolSum > 0) {
          for (final s in pool) {
            s.fraction += (s.fraction / poolSum) * residue;
          }
        }
        residue = 0;
      }
    }

    if (slots.isEmpty) {
      notes.add('no_heirs');
      return InheritanceResult(
        grossEstate: input.netEstate,
        wasiyyahDeducted: wasiyyah,
        distributable: distributable,
        allocations: const [],
        notes: notes,
      );
    }

    final merged = <String, _Slot>{};
    for (final s in slots) {
      if (merged.containsKey(s.heirId)) {
        merged[s.heirId]!.fraction += s.fraction;
      } else {
        merged[s.heirId] = _Slot(s.heirId, s.fraction, count: s.count);
      }
    }

    final allocations = merged.values
        .map(
          (s) => HeirAllocation(
            heirId: s.heirId,
            count: s.count,
            shareFraction: s.fraction,
            amount: distributable * s.fraction,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return InheritanceResult(
      grossEstate: input.netEstate,
      wasiyyahDeducted: wasiyyah,
      distributable: distributable,
      allocations: allocations,
      awlApplied: awlApplied,
      raddApplied: raddApplied,
      notes: notes,
    );
  }
}

class _Slot {
  final String heirId;
  double fraction;
  final int count;

  _Slot(this.heirId, this.fraction, {this.count = 1});
}
