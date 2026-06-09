class SchoolSlugs {
  static const hanafi = 'hanafi';
  static const maliki = 'maliki';
  static const shafii = 'shafii';
  static const hanbali = 'hanbali';
  static const jafari = 'jafari';

  static const all = [hanafi, maliki, shafii, hanbali, jafari];

  static String? fromDbName(String? name) {
    if (name == null) return null;
    switch (name) {
      case 'Hanafi':
        return hanafi;
      case 'Maliki':
        return maliki;
      case 'Shafi\'i':
        return shafii;
      case 'Hanbali':
        return hanbali;
      case 'Ja\'fari':
        return jafari;
      default:
        return null;
    }
  }
}
