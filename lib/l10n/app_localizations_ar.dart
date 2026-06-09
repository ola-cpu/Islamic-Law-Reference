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

  @override
  String get mediaLibrary => 'مكتبة الوسائط';

  @override
  String get comparisonTable => 'جدول مقارنة المذاهب';

  @override
  String get schoolTitle => 'المذهب';

  @override
  String get legalOpinion => 'الرأي القانوني';

  @override
  String get mediaSectionTitle => 'الوسائط والرسوم التوضيحية';

  @override
  String get illustration => 'توضيح';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get close => 'إغلاق';

  @override
  String get hajjSteps => 'خطوات الحج';

  @override
  String get noMediaFound => 'لم يتم العثور على وسائط.';

  @override
  String get languageEn => 'الإنجليزية';

  @override
  String get languageFr => 'الفرنسية';

  @override
  String get languageAr => 'العربية';

  @override
  String get languageRu => 'الروسية';

  @override
  String get languageZh => 'الصينية';

  @override
  String get hajjStep1Desc => 'الدخول في حالة الإحرام';

  @override
  String get hajjStep2Desc => 'الانطلاق إلى منى في 8 ذو الحجة';

  @override
  String get hajjStep3Desc => 'يوم عرفة (ذروة الحج)';

  @override
  String get hajjStep4Desc => 'جمع الحصى';

  @override
  String get hajjStep5Desc => 'رمي الجمرات في منى';

  @override
  String get hajjStep6Desc => 'الطواف حول الكعبة والسعي';

  @override
  String get hajjStep7Desc => 'النحر وانتهاء الحج';

  @override
  String get relatedTopics => 'المواضيع ذات الصلة';

  @override
  String get filterBySchool => 'تصفية حسب المذهب';

  @override
  String get filterByCategory => 'تصفية حسب الفئة';

  @override
  String get dailyTopic => 'موضوع اليوم';

  @override
  String get readMore => 'اقرأ المزيد ←';

  @override
  String get myLibrary => 'مكتبتي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get readingHistory => 'السجل';

  @override
  String get noFavorites =>
      'لا توجد مفضلات بعد. اضغط على القلب في أي موضوع لحفظه هنا.';

  @override
  String get noHistory => 'لا يوجد سجل قراءة بعد. استكشف المواضيع لتظهر هنا.';

  @override
  String topicsExplored(int read, int total) {
    return '$read مواضيع مستكشفة من $total';
  }

  @override
  String get learnHub => 'تعلّم';

  @override
  String get learnHubSubtitle => 'راجع بالبطاقات واختبر معلوماتك بالاختبارات.';

  @override
  String get flashcards => 'بطاقات';

  @override
  String cardCount(int count) {
    return '$count بطاقات';
  }

  @override
  String get quiz => 'اختبار';

  @override
  String get quizGeneral => 'اختبار الفقه العام';

  @override
  String quizQuestionCount(int count) {
    return '$count أسئلة';
  }

  @override
  String get question => 'سؤال';

  @override
  String get answer => 'جواب';

  @override
  String get tapToFlip => 'اضغط على البطاقة للقلب';

  @override
  String get reviewAgain => 'مراجعة';

  @override
  String get knewIt => 'أعرف';

  @override
  String get finish => 'إنهاء';

  @override
  String get deckComplete => 'اكتملت المجموعة!';

  @override
  String deckCompleteMessage(int count) {
    return 'راجعت جميع البطاقات ($count).';
  }

  @override
  String get quizResults => 'نتائج الاختبار';

  @override
  String quizScore(int score, int total) {
    return '$score / $total صحيحة';
  }

  @override
  String get quizPassed => 'أحسنت! حصلت على شارة بطل الاختبار.';

  @override
  String get quizTryAgain => 'واصل الدراسة — يمكنك التحسن!';

  @override
  String get nextQuestion => 'السؤال التالي';

  @override
  String get share => 'مشاركة';

  @override
  String get badges => 'الشارات';

  @override
  String badgesProgress(int unlocked, int total) {
    return '$unlocked / $total شارات مفتوحة';
  }

  @override
  String get guidedCourses => 'مسارات موجهة';

  @override
  String get guidedCoursesDesc => 'مسارات 7 أيام للتعلم خطوة بخطوة.';

  @override
  String courseProgress(int done, int total) {
    return '$done / $total أيام مكتملة';
  }

  @override
  String courseCount(int count) {
    return '$count مسار متاح';
  }

  @override
  String get courseComplete => 'اكتمل المسار! حصلت على شارة الخريج.';

  @override
  String get tools => 'أدوات';

  @override
  String get zakatCalculator => 'حاسبة الزكاة';

  @override
  String get zakatCalculatorShort => 'قدّر زكاتك حسب النصاب';

  @override
  String get zakatCalculatorDesc =>
      'أدخل ثروتك للتحقق من النصاب (85غ ذهب) وحساب 2.5%.';

  @override
  String get goldGrams => 'الذهب (غرام)';

  @override
  String get goldGramsHint => 'مثال: 50';

  @override
  String get silverGrams => 'الفضة (غرام)';

  @override
  String get silverGramsHint => 'مثال: 200';

  @override
  String get cashAmount => 'النقد والادخار';

  @override
  String get cashAmountHint => 'مثال: 5000';

  @override
  String get goldPricePerGram => 'سعر الذهب للغرام';

  @override
  String get goldPriceHint => 'العملة المحلية';

  @override
  String get calculateZakat => 'احسب';

  @override
  String zakatDue(String amount) {
    return 'الزكاة المستحقة: $amount';
  }

  @override
  String get belowNisab => 'أقل من النصاب — لا زكاة';

  @override
  String zakatCalcDetail(
    String gold,
    String silver,
    String cash,
    String nisab,
  ) {
    return 'ذهب: $goldغ · فضة: $silverغ · نقد: $cash · النصاب ≈ $nisab';
  }

  @override
  String get zakatRateNote => 'النسبة: 2.5% بعد حول كامل.';

  @override
  String get learnMoreZakat => 'المزيد عن الزكاة';

  @override
  String get zakatTopicHint => 'فتح موضوع النصاب';

  @override
  String get seasonRamadan => 'موسم رمضان';

  @override
  String get seasonRamadanDesc => 'مواضيع الصيام والعبادة';

  @override
  String get seasonHajj => 'موسم الحج';

  @override
  String get seasonHajjDesc => 'مواضيع الحج';

  @override
  String get listenQuran => 'استماع للآية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get hijriDate => 'التاريخ الهجري';

  @override
  String get languageSetting => 'اللغة';

  @override
  String get themeSetting => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get about => 'حول التطبيق';

  @override
  String appVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get seasonShaaban => 'شعبان — استعد لرمضان';

  @override
  String get seasonShaabanDesc => 'مواضيع للتحضير للشهر الفضيل';

  @override
  String get allSchools => 'جميع المذاهب';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get applyFilters => 'تطبيق';

  @override
  String get dashboard => 'لوحة التقدم';

  @override
  String explorationLevel(int percent) {
    return 'الاستكشاف: $percent٪';
  }

  @override
  String coursesCompleted(int done, int total) {
    return '$done مسار من $total';
  }

  @override
  String get courseProgressTitle => 'تقدم المسارات';

  @override
  String get exportLibrary => 'تصدير المكتبة';

  @override
  String get onboardingTitle1 => 'موسوعة فقهية دون اتصال';

  @override
  String get onboardingDesc1 =>
      'استكشف مئات المواضيع الفقهية الإسلامية، مصنّفة حسب الفئة والمذهب.';

  @override
  String get onboardingTitle2 => 'تعلّم بالممارسة';

  @override
  String get onboardingDesc2 =>
      'بطاقات، اختبارات، مسارات موجهة وشارات لتثبيت معرفتك.';

  @override
  String get onboardingTitle3 => 'تتبّع تقدمك';

  @override
  String get onboardingDesc3 =>
      'المفضلة، الملاحظات الشخصية ولوحة التقدم لمتابعة رحلتك.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get skip => 'تخطّ';

  @override
  String get myMadhhab => 'مذهبي';

  @override
  String get myMadhhabDesc => 'إبراز مذهبك المفضل في صفحات المواضيع';

  @override
  String get myMadhhabLabel => 'مذهبي';

  @override
  String get noSchoolPreference => 'بلا تفضيل';

  @override
  String get dailyReminder => 'تذكير موضوع اليوم';

  @override
  String get dailyReminderDesc => 'عرض تذكير في الرئيسية حتى قراءة موضوع اليوم';

  @override
  String get dailyReminderBanner => 'موضوع اليوم — اقرأه اليوم';

  @override
  String get practicalCases => 'حالات عملية';

  @override
  String get practicalCasesDesc => 'سيناريوهات « ماذا لو؟ » مع مواقف المذاهب';

  @override
  String get caseCompleted => 'مكتمل';

  @override
  String get casePending => 'للحل';

  @override
  String get chooseAnswer => 'اختر إجابة';

  @override
  String get checkAnswer => 'تحقق';

  @override
  String get correctAnswer => 'إجابة صحيحة!';

  @override
  String get wrongAnswer => 'ليست دقيقة — إليك التفسير';

  @override
  String get finishCase => 'إنهاء الحالة';

  @override
  String get schoolPositions => 'مواقف المذاهب';

  @override
  String readingStreak(int days) {
    return '$days أيام متتالية';
  }

  @override
  String get readingStreakDesc => 'أنت تقرأ بانتظام — واصل!';

  @override
  String get suggestedTopic => 'موضوع مقترح لك';

  @override
  String get homeWidget => 'ودجت الشاشة الرئيسية';

  @override
  String get homeWidgetDesc =>
      'أضف ودجت «موضوع اليوم» من قائمة الودجات في أندرويد';

  @override
  String get pushNotificationTitle => 'موضوع اليوم';

  @override
  String get exportAsText => 'تصدير كنص';

  @override
  String get exportAsPdf => 'تصدير PDF';

  @override
  String get noneLabel => '(لا شيء)';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get backupDataDesc => 'المفضلة والملاحظات والتقدم والشارات والإعدادات';

  @override
  String get exportBackup => 'تصدير النسخة الاحتياطية';

  @override
  String get importBackup => 'استعادة نسخة احتياطية';

  @override
  String get backupRestored => 'تمت الاستعادة بنجاح';

  @override
  String get backupFailed => 'فشلت الاستعادة';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearRecentSearches => 'مسح';

  @override
  String get zenMode => 'وضع القراءة الهادئة';

  @override
  String get readAloud => 'قراءة بصوت عالٍ';

  @override
  String get increaseFont => 'تكبير الخط';

  @override
  String get decreaseFont => 'تصغير الخط';

  @override
  String get compareSchools => 'مقارنة المذاهب';

  @override
  String get compareHubDesc => 'مواضيع بمواقف من عدة مذاهب';

  @override
  String get noComparisonAvailable => 'لا توجد مقارنة متاحة';

  @override
  String get fullComparison => 'مقارنة كاملة';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLearn => 'تعلّم';

  @override
  String get navSearch => 'بحث';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navProfile => 'الملف';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get dailyQuestion => 'سؤال اليوم';

  @override
  String get experienceLevel => 'مستوى الخبرة';

  @override
  String get experienceLevelDesc => 'تخصيص عرض المواضيع';

  @override
  String get beginnerMode => 'وضع المبتدئ';

  @override
  String get beginnerModeDesc => 'ملخص ومذهب واحد في كل مرة';

  @override
  String get studentMode => 'وضع الطالب';

  @override
  String get studentModeDesc => 'مقارنة كاملة ومصادر مفصلة';

  @override
  String get beginnerModeActive => 'وضع المبتدئ مفعّل';

  @override
  String get showAllSchools => 'عرض جميع المذاهب';

  @override
  String get methodology => 'المنهجية';

  @override
  String get methodologyShort => 'المصادر والحدود والإرشاد';

  @override
  String get methodologyTitle => 'كيف نعمل';

  @override
  String get methodologyBody =>
      'المواقف مأخوذة من كتب معترف بها للمذاهب الخمسة. كل موضوع يذكر المصادر مع درجة الأصالة عند توفرها. التطبيق لا يغني عن استشارة عالم مؤهل.';

  @override
  String get methodologySources => 'المصادر والأصالة';

  @override
  String get methodologySourcesBody =>
      'الأحاديث مصنفة (صحيح، حسن، ضعيف، موضوع) عند توفر المعلومة.';

  @override
  String get askScholar => 'اسأل عالماً';

  @override
  String get askScholarDesc => 'للفتوى الشخصية، استخدم منصة معترف بها:';

  @override
  String get disclaimerGeneral =>
      'هذا التطبيق تعليمي. للحالات المعقدة، استشر عالماً مختصاً.';

  @override
  String get sensitiveTopicDisclaimer =>
      'موضوع حساس — استشر عالماً قبل أي قرار.';

  @override
  String get sourceReference => 'المرجع';

  @override
  String get skillTree => 'شجرة المهارات';

  @override
  String skillProgress(int read, int total) {
    return '$read/$total مواضيع';
  }

  @override
  String get srsMode => 'التكرار المتباعد';

  @override
  String get examMode => 'وضع الامتحان';

  @override
  String get examModeDesc => 'بدون تصحيح فوري';

  @override
  String get consensusOnly => 'الإجماع فقط';

  @override
  String get noConsensusFound => 'لم يُعثر على إجماع';

  @override
  String get scenarioFinder => 'إيجاد سيناريو';

  @override
  String get scenarioFinderDesc => 'صف حالتك للعثور على حالة عملية';

  @override
  String get scenarioFinderHint => 'مثال: صيام، سفر، زواج…';

  @override
  String get noScenariosFound => 'لا سيناريوهات';

  @override
  String get exportCertificate => 'تصدير الشهادة';

  @override
  String get certificateTitle => 'شهادة إتمام المسار';

  @override
  String get certificateDate => 'التاريخ:';

  @override
  String get situationAdvisor => 'مستشار الحالة';

  @override
  String get situationAdvisorDesc => 'صف حالتك — مواضيع وسيناريوهات مقترحة';

  @override
  String get situationAdvisorHint => 'مثال: أسافر بالطائرة في رمضان و…';

  @override
  String get situationAdvisorEmpty => 'صف حالتك للحصول على اقتراحات';

  @override
  String get analyzeSituation => 'تحليل';

  @override
  String get noSituationMatches => 'لا اقتراحات — جرّب كلمات أخرى';

  @override
  String get encyclopediaExam => 'امتحان الموسوعة';

  @override
  String get encyclopediaExamDesc => '10 مواضيع، مؤقت، تقييم ذاتي';

  @override
  String get examTopicPrompt => 'هل تعرف هذا الموضوع؟';

  @override
  String get revealAnswer => 'إظهار الملخص';

  @override
  String get readFullTopic => 'قراءة الموضوع كاملاً';

  @override
  String get needStudy => 'يحتاج مراجعة';

  @override
  String get examResults => 'نتائج الامتحان';

  @override
  String examKnownCount(int known, int total) {
    return '$known / $total متقن';
  }

  @override
  String get noExamTopics => 'لا توجد مواضيع كافية';

  @override
  String get exportComparisonPdf => 'تصدير المقارنة PDF';

  @override
  String get encryptedSync => 'مزامنة مشفرة';

  @override
  String get encryptedSyncDesc => 'نسخة AES لـ iCloud وDrive';

  @override
  String get exportEncryptedBackup => 'تصدير نسخة مشفرة';

  @override
  String get importEncryptedBackup => 'استيراد نسخة مشفرة';

  @override
  String get enterPassphrase => 'كلمة المرور';

  @override
  String get passphrase => 'كلمة المرور (8+ أحرف)';

  @override
  String get confirmPassphrase => 'تأكيد';

  @override
  String get encryptedSyncFailed => 'فشل — تحقق من كلمة المرور';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get homeWidgetDescIos => 'ودجت iOS وAndroid — أضف «موضوع اليوم»';

  @override
  String get verifiedContent => 'محتوى موثّق';

  @override
  String get isnadChain => 'سلسلة الرواة (الإسناد)';

  @override
  String get disclaimerHomeBanner =>
      'أداة تعليمية — لا تغني عن استشارة عالم. راجع المنهجية.';

  @override
  String get liteMode => 'الوضع الخفيف';

  @override
  String get liteModeDesc => 'يقلل الحركات للأجهزة البطيئة أو لسهولة الوصول';

  @override
  String get globalMadhhabFilter => 'تصفية المذهب العامة';

  @override
  String get globalMadhhabFilterDesc =>
      'إخفاء المواضيع بلا موقف من مذهبك المفضل';

  @override
  String get ijmaSection => 'إجماع';

  @override
  String get ijmaSectionDesc =>
      'تتفق المذاهب السنية الأربعة الرئيسية على هذا النقطة.';

  @override
  String get divergenceTimeline => 'جدول الاختلافات';

  @override
  String get contextualShortcuts => 'اختصارات';

  @override
  String get shortcutZakat => 'حاسبة الزكاة';
}
