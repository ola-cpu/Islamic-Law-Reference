import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_law_reference/services/inheritance_calculator_service.dart';

void main() {
  double share(List<HeirAllocation> list, String id) =>
      list.firstWhere((a) => a.heirId == id, orElse: () => const HeirAllocation(heirId: '', shareFraction: 0, amount: 0)).shareFraction;

  test('husband, son, daughter, parents — residue to children 2:1', () {
    const input = InheritanceInput(
      netEstate: 120000,
      hasHusband: true,
      sons: 1,
      daughters: 1,
      fatherAlive: true,
      motherAlive: true,
    );
    final result = InheritanceCalculatorService.calculate(input)!;
    expect(share(result.allocations, 'husband'), closeTo(0.25, 0.001));
    expect(share(result.allocations, 'father'), closeTo(1 / 6, 0.001));
    expect(share(result.allocations, 'mother'), closeTo(1 / 6, 0.001));
    expect(share(result.allocations, 'son'), closeTo(10 / 36, 0.001));
    expect(share(result.allocations, 'daughter'), closeTo(5 / 36, 0.001));
    final total = result.allocations.fold<double>(0, (s, a) => s + a.amount);
    expect(total, closeTo(120000, 1));
  });

  test('husband, two daughters, mother triggers awl', () {
    const input = InheritanceInput(
      netEstate: 90000,
      hasHusband: true,
      daughters: 2,
      motherAlive: true,
    );
    final result = InheritanceCalculatorService.calculate(input)!;
    expect(result.awlApplied, isTrue);
    final totalFrac = result.allocations.fold<double>(0, (s, a) => s + a.shareFraction);
    expect(totalFrac, closeTo(1, 0.001));
  });

  test('wasiyyah capped at one third', () {
    const input = InheritanceInput(
      netEstate: 30000,
      wasiyyah: 20000,
      wives: 1,
      sons: 1,
    );
    final result = InheritanceCalculatorService.calculate(input)!;
    expect(result.wasiyyahDeducted, 10000);
    expect(result.distributable, 20000);
    expect(result.notes, contains('wasiyyah_capped'));
  });

  test('rejects husband and wives together', () {
    const input = InheritanceInput(netEstate: 1000, hasHusband: true, wives: 1);
    expect(InheritanceCalculatorService.calculate(input), isNull);
  });
}
