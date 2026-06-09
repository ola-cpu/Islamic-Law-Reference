import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../router/app_router.dart';
import '../services/inheritance_calculator_service.dart';

class InheritanceCalculatorScreen extends StatefulWidget {
  const InheritanceCalculatorScreen({super.key});

  @override
  State<InheritanceCalculatorScreen> createState() => _InheritanceCalculatorScreenState();
}

class _InheritanceCalculatorScreenState extends State<InheritanceCalculatorScreen> {
  final _estateController = TextEditingController();
  final _wasiyyahController = TextEditingController(text: '0');

  _SpouseChoice _spouse = _SpouseChoice.none;
  int _wives = 1;
  int _sons = 0;
  int _daughters = 0;
  bool _father = false;
  bool _mother = false;
  int _fullBrothers = 0;
  int _fullSisters = 0;

  InheritanceResult? _result;

  @override
  void dispose() {
    _estateController.dispose();
    _wasiyyahController.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final estate = double.tryParse(_estateController.text.replaceAll(',', '.')) ?? 0;
    final wasiyyah = double.tryParse(_wasiyyahController.text.replaceAll(',', '.')) ?? 0;

    final input = InheritanceInput(
      netEstate: estate,
      wasiyyah: wasiyyah,
      hasHusband: _spouse == _SpouseChoice.husband,
      wives: _spouse == _SpouseChoice.wives ? _wives : 0,
      sons: _sons,
      daughters: _daughters,
      fatherAlive: _father,
      motherAlive: _mother,
      fullBrothers: _fullBrothers,
      fullSisters: _fullSisters,
    );

    setState(() => _result = InheritanceCalculatorService.calculate(input));
  }

  String _heirLabel(AppLocalizations l10n, String id) => switch (id) {
        'husband' => l10n.heirHusband,
        'wife' => l10n.heirWife,
        'son' => l10n.heirSon,
        'daughter' => l10n.heirDaughter,
        'father' => l10n.heirFather,
        'mother' => l10n.heirMother,
        'full_brother' => l10n.heirFullBrother,
        'full_sister' => l10n.heirFullSister,
        _ => id,
      };

  String _noteLabel(AppLocalizations l10n, String note) => switch (note) {
        'awl_applied' => l10n.inheritanceNoteAwl,
        'radd_applied' => l10n.inheritanceNoteRadd,
        'wasiyyah_capped' => l10n.inheritanceNoteWasiyyahCapped,
        'no_heirs' => l10n.inheritanceNoteNoHeirs,
        _ => note,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inheritanceCalculator)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _disclaimer(l10n),
          const SizedBox(height: 16),
          Text(l10n.inheritanceCalculatorDesc, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
          const SizedBox(height: 20),
          Text(l10n.inheritanceSectionEstate, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _field(l10n.inheritanceNetEstate, _estateController, l10n.inheritanceNetEstateHint),
          _field(l10n.inheritanceWasiyyah, _wasiyyahController, l10n.inheritanceWasiyyahHint),
          const SizedBox(height: 16),
          Text(l10n.inheritanceSectionSpouse, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<_SpouseChoice>(
            segments: [
              ButtonSegment(value: _SpouseChoice.none, label: Text(l10n.inheritanceNoSpouse)),
              ButtonSegment(value: _SpouseChoice.husband, label: Text(l10n.heirHusband)),
              ButtonSegment(value: _SpouseChoice.wives, label: Text(l10n.heirWife)),
            ],
            selected: {_spouse},
            onSelectionChanged: (s) => setState(() => _spouse = s.first),
          ),
          if (_spouse == _SpouseChoice.wives) ...[
            const SizedBox(height: 8),
            _counter(l10n.inheritanceWivesCount, _wives, 1, 4, (v) => setState(() => _wives = v)),
          ],
          const SizedBox(height: 16),
          Text(l10n.inheritanceSectionChildren, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _counter(l10n.heirSon, _sons, 0, 12, (v) => setState(() => _sons = v)),
          _counter(l10n.heirDaughter, _daughters, 0, 12, (v) => setState(() => _daughters = v)),
          const SizedBox(height: 16),
          Text(l10n.inheritanceSectionParents, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: Text(l10n.heirFather),
            value: _father,
            onChanged: (v) => setState(() => _father = v),
          ),
          SwitchListTile(
            title: Text(l10n.heirMother),
            value: _mother,
            onChanged: (v) => setState(() => _mother = v),
          ),
          const SizedBox(height: 8),
          Text(l10n.inheritanceSectionSiblings, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _counter(l10n.heirFullBrother, _fullBrothers, 0, 8, (v) => setState(() => _fullBrothers = v)),
          _counter(l10n.heirFullSister, _fullSisters, 0, 8, (v) => setState(() => _fullSisters = v)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _calculate(l10n),
            icon: const Icon(Icons.calculate),
            label: Text(l10n.inheritanceCalculate),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            _buildResults(context, l10n, theme, _result!),
          ],
        ],
      ),
    );
  }

  Widget _disclaimer(AppLocalizations l10n) {
    return Material(
      color: Colors.amber.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push(AppRoutes.methodology),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.amber.shade900),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n.inheritanceDisclaimer, style: const TextStyle(fontSize: 12, height: 1.35)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, AppLocalizations l10n, ThemeData theme, InheritanceResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.inheritanceResults, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          l10n.inheritanceDistributable(result.distributable.toStringAsFixed(2)),
          style: TextStyle(color: Colors.grey.shade700),
        ),
        if (result.wasiyyahDeducted > 0)
          Text(
            l10n.inheritanceWasiyyahDeducted(result.wasiyyahDeducted.toStringAsFixed(2)),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        for (final note in result.notes)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_noteLabel(l10n, note), style: TextStyle(color: Colors.orange.shade800, fontSize: 12)),
          ),
        const SizedBox(height: 12),
        if (result.allocations.isEmpty)
          Text(l10n.inheritanceNoteNoHeirs)
        else
          ...result.allocations.map((a) {
            final pct = (a.shareFraction * 100).toStringAsFixed(1);
            final label = _heirLabel(l10n, a.heirId);
            final countSuffix = a.count > 1 ? ' (×${a.count})' : '';
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade100,
                  child: Text(pct, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown.shade800)),
                ),
                title: Text('$label$countSuffix'),
                subtitle: a.count > 1
                    ? Text(l10n.inheritancePerPerson(a.perPersonAmount.toStringAsFixed(2)))
                    : null,
                trailing: Text(
                  a.amount.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            );
          }),
        const SizedBox(height: 8),
        Text(l10n.inheritanceApproximateNote, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
        decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _counter(String label, int value, int min, int max, ValueChanged<int> onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

enum _SpouseChoice { none, husband, wives }
