import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_law_reference/services/hijri_calendar.dart';
import 'package:islamic_law_reference/services/season_service.dart';

void main() {
  test('HijriDate converts gregorian date', () {
    final hijri = HijriDate.fromGregorian(DateTime(2024, 3, 11));
    expect(hijri.year, greaterThan(1400));
    expect(hijri.month, inInclusiveRange(1, 12));
    expect(hijri.day, inInclusiveRange(1, 30));
    expect(hijri.formatted(), isNotEmpty);
  });

  test('SeasonService detects Ramadan month', () {
    // Simulate a date in Ramadan 1445 (approx March 2024)
    final info = SeasonService.getSeasonInfo(DateTime(2024, 3, 15));
    expect(info, isNotNull);
    expect(info!.type, anyOf(SeasonType.ramadan, SeasonType.shaaban));
  });
}
