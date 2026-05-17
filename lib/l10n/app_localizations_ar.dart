// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مرجع القانون الإسلامي';

  @override
  String get searchHint => 'ابحث عن قانون...';

  @override
  String get noResults => 'لم يتم العثور على نتائج.';

  @override
  String get sources => 'المصادر والمراجع:';

  @override
  String get comments => 'تعليقات العلماء:';

  @override
  String get school => 'المدرسة القانونية:';

  @override
  String get personalNotes => 'ملاحظاتي الشخصية:';

  @override
  String get addNoteHint => 'أضف ملاحظة...';

  @override
  String get saveNote => 'حفظ الملاحظة';

  @override
  String get noteSaved => 'تم حفظ الملاحظة!';

  @override
  String get noLaws => 'لم يتم العثور على قوانين.';

  @override
  String get noSources => 'لا توجد مصادر متاحة.';

  @override
  String get schoolHanafi => 'حنفي';

  @override
  String get schoolMaliki => 'مالكي';

  @override
  String get schoolShafii => 'شافعي';

  @override
  String get schoolHanbali => 'حنبلي';

  @override
  String get schoolJafari => 'جعفري';
}
