/// Conversion grégorien → hijri (algorithme tabulaire Umm al-Qura simplifié).
class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate({required this.year, required this.month, required this.day});

  static HijriDate fromGregorian(DateTime date) {
    final jd = _gregorianToJulianDay(date.year, date.month, date.day);
    return _julianDayToHijri(jd);
  }

  String formatted({bool includeDay = true}) {
    const monthsFr = [
      'Muharram', 'Safar', 'Rabi\' al-awwal', 'Rabi\' al-thani',
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', 'Sha\'ban',
      'Ramadan', 'Shawwal', 'Dhul Qi\'dah', 'Dhul Hijjah',
    ];
    final name = month >= 1 && month <= 12 ? monthsFr[month - 1] : '?';
    if (includeDay) return '$day $name $year AH';
    return '$name $year AH';
  }

  static int _gregorianToJulianDay(int y, int m, int d) {
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = y ~/ 100;
    final b = 2 - a + (a ~/ 4);
    return ((365.25 * (y + 4716)).floor() +
            (30.6001 * (m + 1)).floor() +
            d +
            b -
            1524.5)
        .floor();
  }

  static HijriDate _julianDayToHijri(int jd) {
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    var remaining = l - 10631 * n + 354;
    final j = (((10985 - remaining) / 5316).floor() *
            ((50 * remaining) / 17719).floor()) +
        ((remaining / 5670).floor() * ((43 * remaining) / 15238).floor());
    remaining = remaining -
        (((30 - j) / 15).floor() * ((17719 * j) / 50).floor()) -
        ((j / 16).floor() * ((15238 * j) / 43).floor()) +
        29;
    final m = ((24 * remaining) / 709).floor();
    final d = remaining - ((709 * m) / 24).floor();
    final y = 30 * n + j - 30;
    return HijriDate(year: y, month: m, day: d);
  }
}
