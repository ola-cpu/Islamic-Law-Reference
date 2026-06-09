// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '伊斯兰法律参考';

  @override
  String get searchHint => '搜索法律...';

  @override
  String get noResults => '未找到结果。';

  @override
  String get sources => '来源和参考：';

  @override
  String get comments => '学者评论：';

  @override
  String get school => '法律流派：';

  @override
  String get personalNotes => '我的个人笔记：';

  @override
  String get addNoteHint => '添加笔记...';

  @override
  String get saveNote => '保存笔记';

  @override
  String get noteSaved => '笔记已保存！';

  @override
  String get noLaws => '未找到法律。';

  @override
  String get noSources => '无可用来源。';

  @override
  String get schoolHanafi => '哈乃斐';

  @override
  String get schoolMaliki => '马立克';

  @override
  String get schoolShafii => '沙斐仪';

  @override
  String get schoolHanbali => '罕百里';

  @override
  String get schoolJafari => '贾法里';

  @override
  String get mediaLibrary => '媒体库';

  @override
  String get comparisonTable => '教法流派对比表';

  @override
  String get schoolTitle => '流派';

  @override
  String get legalOpinion => '法律意见';

  @override
  String get mediaSectionTitle => '媒体和插图';

  @override
  String get illustration => '插图';

  @override
  String get comingSoon => '即将推出';

  @override
  String get close => '关闭';

  @override
  String get hajjSteps => '朝觐 (Hajj) 步骤';

  @override
  String get noMediaFound => '未找到媒体。';

  @override
  String get languageEn => '英语';

  @override
  String get languageFr => '法语';

  @override
  String get languageAr => '阿拉伯语';

  @override
  String get languageRu => '俄语';

  @override
  String get languageZh => '中文';

  @override
  String get hajjStep1Desc => '进入受戒 (Ihram) 状态。';

  @override
  String get hajjStep2Desc => '在都尔黑哲月 8 日出发前往米纳 (Mina)。';

  @override
  String get hajjStep3Desc => '阿拉法特日（朝觐的高潮）。';

  @override
  String get hajjStep4Desc => '在穆兹代里法 (Muzdalifah) 收集石子。';

  @override
  String get hajjStep5Desc => '在米纳投石。';

  @override
  String get hajjStep6Desc => '在麦加进行环游 (Tawaf) 和奔跑 (Sa\'y)。';

  @override
  String get hajjStep7Desc => '宰牲并结束朝觐仪式。';

  @override
  String get relatedTopics => '相关话题';

  @override
  String get filterBySchool => '按流派筛选';

  @override
  String get filterByCategory => '按类别筛选';

  @override
  String get dailyTopic => '每日主题';

  @override
  String get readMore => '阅读更多 →';

  @override
  String get myLibrary => '我的书库';

  @override
  String get favorites => '收藏';

  @override
  String get readingHistory => '历史';

  @override
  String get noFavorites => '暂无收藏。点击主题上的心形图标即可保存到这里。';

  @override
  String get noHistory => '暂无阅读历史。浏览主题后会显示在这里。';

  @override
  String topicsExplored(int read, int total) {
    return '已探索 $read 个主题，共 $total 个';
  }

  @override
  String get learnHub => '学习';

  @override
  String get learnHubSubtitle => '用闪卡复习，用测验检验知识。';

  @override
  String get flashcards => '闪卡';

  @override
  String cardCount(int count) {
    return '$count 张卡片';
  }

  @override
  String get quiz => '测验';

  @override
  String get quizGeneral => '伊斯兰法综合测验';

  @override
  String quizQuestionCount(int count) {
    return '$count 道题';
  }

  @override
  String get question => '问题';

  @override
  String get answer => '答案';

  @override
  String get tapToFlip => '点击卡片翻转';

  @override
  String get reviewAgain => '再看';

  @override
  String get knewIt => '知道了';

  @override
  String get finish => '完成';

  @override
  String get deckComplete => '卡组完成！';

  @override
  String deckCompleteMessage(int count) {
    return '您已复习全部 $count 张卡片。';
  }

  @override
  String get quizResults => '测验结果';

  @override
  String quizScore(int score, int total) {
    return '$score / $total 正确';
  }

  @override
  String get quizPassed => '做得好！您获得了测验大师徽章。';

  @override
  String get quizTryAgain => '继续学习——您可以做得更好！';

  @override
  String get nextQuestion => '下一题';

  @override
  String get share => '分享';

  @override
  String get badges => '徽章';

  @override
  String badgesProgress(int unlocked, int total) {
    return '已解锁 $unlocked / $total 个徽章';
  }

  @override
  String get guidedCourses => '引导课程';

  @override
  String get guidedCoursesDesc => '7天结构化学习路径。';

  @override
  String courseProgress(int done, int total) {
    return '已完成 $done / $total 天';
  }

  @override
  String courseCount(int count) {
    return '$count 个课程';
  }

  @override
  String get courseComplete => '课程完成！获得毕业生徽章。';

  @override
  String get tools => '工具';

  @override
  String get zakatCalculator => '天课计算器';

  @override
  String get zakatCalculatorShort => '根据尼萨布估算天课';

  @override
  String get zakatCalculatorDesc => '输入财富以检查是否达到尼萨布（85克金）并计算2.5%。';

  @override
  String get goldGrams => '黄金（克）';

  @override
  String get goldGramsHint => '例如 50';

  @override
  String get silverGrams => '白银（克）';

  @override
  String get silverGramsHint => '例如 200';

  @override
  String get cashAmount => '现金与储蓄';

  @override
  String get cashAmountHint => '例如 5000';

  @override
  String get goldPricePerGram => '黄金每克价格';

  @override
  String get goldPriceHint => '本地货币';

  @override
  String get calculateZakat => '计算';

  @override
  String zakatDue(String amount) {
    return '应缴天课：$amount';
  }

  @override
  String get belowNisab => '未达尼萨布 — 无需缴纳';

  @override
  String zakatCalcDetail(
    String gold,
    String silver,
    String cash,
    String nisab,
  ) {
    return '金：${gold}g · 银：${silver}g · 现金：$cash · 尼萨布 ≈ $nisab';
  }

  @override
  String get zakatRateNote => '费率：持有一年后为2.5%。';

  @override
  String get learnMoreZakat => '了解更多天课知识';

  @override
  String get zakatTopicHint => '打开尼萨布主题';

  @override
  String get seasonRamadan => '斋月季节';

  @override
  String get seasonRamadanDesc => '禁食与礼拜精选主题';

  @override
  String get seasonHajj => '朝觐季节';

  @override
  String get seasonHajjDesc => '朝觐精选主题';

  @override
  String get listenQuran => '听经文';

  @override
  String get settings => '设置';

  @override
  String get hijriDate => '伊斯兰历日期';

  @override
  String get languageSetting => '语言';

  @override
  String get themeSetting => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get about => '关于';

  @override
  String appVersion(String version) {
    return '版本 $version';
  }

  @override
  String get seasonShaaban => '舍尔邦月 — 准备斋月';

  @override
  String get seasonShaabanDesc => '为圣月做准备的精选主题';

  @override
  String get allSchools => '所有流派';

  @override
  String get allCategories => '所有类别';

  @override
  String get applyFilters => '应用';

  @override
  String get dashboard => '进度面板';

  @override
  String explorationLevel(int percent) {
    return '探索进度：$percent%';
  }

  @override
  String coursesCompleted(int done, int total) {
    return '已完成 $done / $total 个课程';
  }

  @override
  String get courseProgressTitle => '课程进度';

  @override
  String get exportLibrary => '导出收藏';

  @override
  String get onboardingTitle1 => '离线伊斯兰法学百科';

  @override
  String get onboardingDesc1 => '浏览数百个伊斯兰法律主题，按类别和学派分类。';

  @override
  String get onboardingTitle2 => '在实践中学习';

  @override
  String get onboardingDesc2 => '闪卡、测验、引导课程和徽章，巩固您的知识。';

  @override
  String get onboardingTitle3 => '追踪您的进度';

  @override
  String get onboardingDesc3 => '收藏、个人笔记和进度面板，记录您的学习旅程。';

  @override
  String get getStarted => '开始';

  @override
  String get skip => '跳过';

  @override
  String get myMadhhab => '我的学派';

  @override
  String get myMadhhabDesc => '在主题页突出您偏好的法学流派';

  @override
  String get myMadhhabLabel => '我的学派';

  @override
  String get noSchoolPreference => '无偏好';

  @override
  String get dailyReminder => '每日主题提醒';

  @override
  String get dailyReminderDesc => '在首页显示提醒，直到阅读今日主题';

  @override
  String get dailyReminderBanner => '今日主题 — 今天阅读';

  @override
  String get practicalCases => '实践案例';

  @override
  String get practicalCasesDesc => '「如果…？」情景及各流派观点';

  @override
  String get caseCompleted => '已完成';

  @override
  String get casePending => '待解答';

  @override
  String get chooseAnswer => '选择答案';

  @override
  String get checkAnswer => '检查';

  @override
  String get correctAnswer => '回答正确！';

  @override
  String get wrongAnswer => '不完全正确 — 请看解释';

  @override
  String get finishCase => '完成案例';

  @override
  String get schoolPositions => '各流派观点';

  @override
  String readingStreak(int days) {
    return '连续 $days 天';
  }

  @override
  String get readingStreakDesc => '您坚持阅读——继续保持！';

  @override
  String get suggestedTopic => '为您推荐';

  @override
  String get homeWidget => '主屏幕小组件';

  @override
  String get homeWidgetDesc => '从 Android 小组件菜单添加「每日主题」小组件';

  @override
  String get pushNotificationTitle => '每日主题';

  @override
  String get exportAsText => '导出为文本';

  @override
  String get exportAsPdf => '导出为 PDF';

  @override
  String get noneLabel => '（无）';

  @override
  String get backupData => '数据备份';

  @override
  String get backupDataDesc => '收藏、笔记、进度、徽章和设置';

  @override
  String get exportBackup => '导出备份';

  @override
  String get importBackup => '恢复备份';

  @override
  String get backupRestored => '备份恢复成功';

  @override
  String get backupFailed => '恢复失败';

  @override
  String get recentSearches => '最近搜索';

  @override
  String get clearRecentSearches => '清除';

  @override
  String get zenMode => '禅意阅读模式';

  @override
  String get readAloud => '朗读';

  @override
  String get increaseFont => '增大字体';

  @override
  String get decreaseFont => '减小字体';

  @override
  String get compareSchools => '学派对比';

  @override
  String get compareHubDesc => '包含多个教法学派观点的主题';

  @override
  String get noComparisonAvailable => '暂无对比内容';

  @override
  String get fullComparison => '完整对比';
}
