// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Справочник исламского права';

  @override
  String get searchHint => 'Поиск закона...';

  @override
  String get noResults => 'Результатов не найдено.';

  @override
  String get sources => 'Источники и ссылки:';

  @override
  String get comments => 'Комментарии ученых:';

  @override
  String get school => 'Правовая школа:';

  @override
  String get personalNotes => 'Мои личные заметки:';

  @override
  String get addNoteHint => 'Добавить заметку...';

  @override
  String get saveNote => 'Сохранить заметку';

  @override
  String get noteSaved => 'Заметка сохранена!';

  @override
  String get noLaws => 'Законов не найдено.';

  @override
  String get noSources => 'Источники отсутствуют.';

  @override
  String get schoolHanafi => 'Ханафитский';

  @override
  String get schoolMaliki => 'Маликитский';

  @override
  String get schoolShafii => 'Шафиитский';

  @override
  String get schoolHanbali => 'Ханбалитский';

  @override
  String get schoolJafari => 'Джафаритский';

  @override
  String get mediaLibrary => 'Медиатека';

  @override
  String get comparisonTable => 'Сравнительная таблица школ';

  @override
  String get schoolTitle => 'Школа';

  @override
  String get legalOpinion => 'Правовое мнение';

  @override
  String get mediaSectionTitle => 'Медиа и иллюстрации';

  @override
  String get illustration => 'Иллюстрация';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get close => 'Закрыть';

  @override
  String get hajjSteps => 'Этапы паломничества (Хадж)';

  @override
  String get noMediaFound => 'Медиафайлов не найдено.';

  @override
  String get languageEn => 'Английский';

  @override
  String get languageFr => 'Французский';

  @override
  String get languageAr => 'Арабский';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageZh => 'Китайский';

  @override
  String get hajjStep1Desc => 'Вхождение в состояние ихрама.';

  @override
  String get hajjStep2Desc => 'Отправление в Мину 8-го числа Зуль-хиджа.';

  @override
  String get hajjStep3Desc => 'День Арафат (кульминация Хаджа).';

  @override
  String get hajjStep4Desc => 'Сбор камешков в Муздалифе.';

  @override
  String get hajjStep5Desc => 'Бросание камней в Мине.';

  @override
  String get hajjStep6Desc => 'Таваф и Сай в Мекке.';

  @override
  String get hajjStep7Desc => 'Жертвоприношение и завершение обрядов Хаджа.';

  @override
  String get relatedTopics => 'Связанные темы';

  @override
  String get filterBySchool => 'Фильтровать по школе';

  @override
  String get filterByCategory => 'Фильтровать по категории';

  @override
  String get dailyTopic => 'Тема дня';

  @override
  String get readMore => 'Читать далее →';

  @override
  String get myLibrary => 'Моя библиотека';

  @override
  String get favorites => 'Избранное';

  @override
  String get readingHistory => 'История';

  @override
  String get noFavorites =>
      'Пока нет избранного. Нажмите на сердечко у темы, чтобы сохранить её здесь.';

  @override
  String get noHistory =>
      'История чтения пока пуста. Изучайте темы, и они появятся здесь.';

  @override
  String topicsExplored(int read, int total) {
    return '$read тем изучено из $total';
  }

  @override
  String get learnHub => 'Учиться';

  @override
  String get learnHubSubtitle =>
      'Повторяйте с карточками и проверяйте знания в викторине.';

  @override
  String get flashcards => 'Карточки';

  @override
  String cardCount(int count) {
    return '$count карточек';
  }

  @override
  String get quiz => 'Викторина';

  @override
  String get quizGeneral => 'Общая викторина по фикху';

  @override
  String quizQuestionCount(int count) {
    return '$count вопросов';
  }

  @override
  String get question => 'Вопрос';

  @override
  String get answer => 'Ответ';

  @override
  String get tapToFlip => 'Нажмите, чтобы перевернуть';

  @override
  String get reviewAgain => 'Повторить';

  @override
  String get knewIt => 'Знаю';

  @override
  String get finish => 'Завершить';

  @override
  String get deckComplete => 'Колода пройдена!';

  @override
  String deckCompleteMessage(int count) {
    return 'Вы просмотрели все $count карточек.';
  }

  @override
  String get quizResults => 'Результаты';

  @override
  String quizScore(int score, int total) {
    return '$score / $total правильных';
  }

  @override
  String get quizPassed => 'Отлично! Вы получили значок мастера викторины.';

  @override
  String get quizTryAgain => 'Продолжайте учиться!';

  @override
  String get nextQuestion => 'Следующий вопрос';

  @override
  String get share => 'Поделиться';

  @override
  String get badges => 'Значки';

  @override
  String badgesProgress(int unlocked, int total) {
    return '$unlocked / $total значков получено';
  }

  @override
  String get guidedCourses => 'Курсы';

  @override
  String get guidedCoursesDesc => '7-дневные маршруты для пошагового обучения.';

  @override
  String courseProgress(int done, int total) {
    return '$done / $total дней завершено';
  }

  @override
  String courseCount(int count) {
    return '$count курс(ов)';
  }

  @override
  String get courseComplete => 'Курс завершён! Получен значок выпускника.';

  @override
  String get tools => 'Инструменты';

  @override
  String get zakatCalculator => 'Калькулятор закята';

  @override
  String get zakatCalculatorShort => 'Оцените закят по нисабу';

  @override
  String get zakatCalculatorDesc =>
      'Введите богатство для проверки нисаба (85г золота) и расчёта 2.5%.';

  @override
  String get goldGrams => 'Золото (граммы)';

  @override
  String get goldGramsHint => 'напр. 50';

  @override
  String get silverGrams => 'Серебро (граммы)';

  @override
  String get silverGramsHint => 'напр. 200';

  @override
  String get cashAmount => 'Наличные и сбережения';

  @override
  String get cashAmountHint => 'напр. 5000';

  @override
  String get goldPricePerGram => 'Цена золота за грамм';

  @override
  String get goldPriceHint => 'Местная валюта';

  @override
  String get calculateZakat => 'Рассчитать';

  @override
  String zakatDue(String amount) {
    return 'Закят: $amount';
  }

  @override
  String get belowNisab => 'Ниже нисаба — закят не due';

  @override
  String zakatCalcDetail(
    String gold,
    String silver,
    String cash,
    String nisab,
  ) {
    return 'Золото: $goldг · Серебро: $silverг · Наличные: $cash · Нисаб ≈ $nisab';
  }

  @override
  String get zakatRateNote => 'Ставка: 2.5% после года владения.';

  @override
  String get learnMoreZakat => 'Подробнее о закяте';

  @override
  String get zakatTopicHint => 'Открыть тему нисаба';

  @override
  String get seasonRamadan => 'Сезон Рамадана';

  @override
  String get seasonRamadanDesc => 'Темы поста и поклонения';

  @override
  String get seasonHajj => 'Сезон Хаджа';

  @override
  String get seasonHajjDesc => 'Темы паломничества';

  @override
  String get listenQuran => 'Прослушать аят';

  @override
  String get settings => 'Настройки';

  @override
  String get hijriDate => 'Дата хиджры';

  @override
  String get languageSetting => 'Язык';

  @override
  String get themeSetting => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get about => 'О приложении';

  @override
  String appVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get seasonShaaban => 'Ша\'бан — подготовка к Рамадану';

  @override
  String get seasonShaabanDesc => 'Темы для подготовки к священному месяцу';

  @override
  String get allSchools => 'Все школы';

  @override
  String get allCategories => 'Все категории';

  @override
  String get applyFilters => 'Применить';

  @override
  String get dashboard => 'Панель прогресса';

  @override
  String explorationLevel(int percent) {
    return 'Изучено: $percent%';
  }

  @override
  String coursesCompleted(int done, int total) {
    return '$done курсов из $total';
  }

  @override
  String get courseProgressTitle => 'Прогресс курсов';

  @override
  String get exportLibrary => 'Экспорт библиотеки';

  @override
  String get onboardingTitle1 => 'Офлайн-энциклопедия исламского права';

  @override
  String get onboardingDesc1 =>
      'Изучайте сотни исламских правовых тем по категориям и школам.';

  @override
  String get onboardingTitle2 => 'Учитесь на практике';

  @override
  String get onboardingDesc2 =>
      'Карточки, викторины, курсы и значки для закрепления знаний.';

  @override
  String get onboardingTitle3 => 'Следите за прогрессом';

  @override
  String get onboardingDesc3 =>
      'Избранное, заметки и панель для отслеживания вашего пути.';

  @override
  String get getStarted => 'Начать';

  @override
  String get skip => 'Пропустить';

  @override
  String get myMadhhab => 'Мой мазхаб';

  @override
  String get myMadhhabDesc => 'Выделять предпочитаемую школу на страницах тем';

  @override
  String get myMadhhabLabel => 'Моя школа';

  @override
  String get noSchoolPreference => 'Без предпочтения';

  @override
  String get dailyReminder => 'Напоминание о теме дня';

  @override
  String get dailyReminderDesc =>
      'Показывать напоминание, пока тема дня не прочитана';

  @override
  String get dailyReminderBanner => 'Тема дня — прочитайте сегодня';

  @override
  String get practicalCases => 'Практические случаи';

  @override
  String get practicalCasesDesc => 'Сценарии «А что если…?» с позициями школ';

  @override
  String get caseCompleted => 'Завершено';

  @override
  String get casePending => 'К решению';

  @override
  String get chooseAnswer => 'Выберите ответ';

  @override
  String get checkAnswer => 'Проверить';

  @override
  String get correctAnswer => 'Верно!';

  @override
  String get wrongAnswer => 'Не совсем — вот объяснение';

  @override
  String get finishCase => 'Завершить случай';

  @override
  String get schoolPositions => 'Позиции школ';

  @override
  String readingStreak(int days) {
    return 'Серия $days дней';
  }

  @override
  String get readingStreakDesc => 'Вы читаете регулярно — так держать!';

  @override
  String get suggestedTopic => 'Рекомендуемая тема';

  @override
  String get homeWidget => 'Виджет главного экрана';

  @override
  String get homeWidgetDesc =>
      'Добавьте виджет «Тема дня» из меню виджетов Android';

  @override
  String get pushNotificationTitle => 'Тема дня';

  @override
  String get exportAsText => 'Экспорт в текст';

  @override
  String get exportAsPdf => 'Экспорт в PDF';

  @override
  String get noneLabel => '(нет)';

  @override
  String get backupData => 'Резервное копирование';

  @override
  String get backupDataDesc =>
      'Избранное, заметки, прогресс, значки и настройки';

  @override
  String get exportBackup => 'Экспорт резервной копии';

  @override
  String get importBackup => 'Восстановить копию';

  @override
  String get backupRestored => 'Резервная копия восстановлена';

  @override
  String get backupFailed => 'Ошибка восстановления';

  @override
  String get recentSearches => 'Недавние поиски';

  @override
  String get clearRecentSearches => 'Очистить';

  @override
  String get zenMode => 'Режим спокойного чтения';

  @override
  String get readAloud => 'Читать вслух';

  @override
  String get increaseFont => 'Увеличить шрифт';

  @override
  String get decreaseFont => 'Уменьшить шрифт';

  @override
  String get compareSchools => 'Сравнение школ';

  @override
  String get compareHubDesc => 'Темы с позициями нескольких мазхабов';

  @override
  String get noComparisonAvailable => 'Сравнение недоступно';

  @override
  String get fullComparison => 'Полное сравнение';
}
