import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/category.dart';
import '../models/topic.dart';
import 'topic_list_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/season_service.dart';
import '../providers/user_provider.dart';
import '../router/app_router.dart';
import '../services/widget_service.dart';
import '../services/daily_question_service.dart';
import '../widgets/skeleton_loader.dart';
import '../data/category_visuals.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? parentCategoryId;
  final String? categoryName;

  const HomeScreen({super.key, this.parentCategoryId, this.categoryName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Category> _categories = [];
  Topic? _dailyTopic;
  Topic? _continueTopic;
  List<Topic> _seasonTopics = [];
  SeasonInfo? _seasonInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final categories = await _dbHelper.getCategories(
        parentId: widget.parentCategoryId,
        locale: userProvider.locale,
      );
      Topic? dailyTopic;
      Topic? continueTopic;
      List<Topic> seasonTopics = [];
      SeasonInfo? seasonInfo;
      if (widget.parentCategoryId == null) {
        dailyTopic = await _dbHelper.getDailyTopic(locale: userProvider.locale);
        continueTopic = await userProvider.getLastReadTopic();
        if (dailyTopic != null) {
          try {
            await WidgetService.updateDailyTopic(dailyTopic);
            await userProvider.syncDailyReminder();
          } catch (_) {
            // Widget / notifications indisponibles sur desktop.
          }
        }
        seasonInfo = SeasonService.getSeasonInfo();
        if (seasonInfo != null) {
          seasonTopics = await _dbHelper.getTopicsByTitles(
            seasonInfo.topicTitlesFr,
            locale: userProvider.locale,
          );
        }
      }
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _dailyTopic = dailyTopic;
        _continueTopic = continueTopic;
        _seasonTopics = seasonTopics;
        _seasonInfo = seasonInfo;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? l10n.appTitle),
        actions: [
          if (widget.parentCategoryId == null) ...[
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              onSelected: (Locale locale) {
                userProvider.setLocale(locale);
                setState(() => _isLoading = true);
                _loadContent();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                PopupMenuItem<Locale>(value: const Locale('en'), child: Text(l10n.languageEn)),
                PopupMenuItem<Locale>(value: const Locale('fr'), child: Text(l10n.languageFr)),
                PopupMenuItem<Locale>(value: const Locale('ar'), child: Text(l10n.languageAr)),
                PopupMenuItem<Locale>(value: const Locale('ru'), child: Text(l10n.languageRu)),
                PopupMenuItem<Locale>(value: const Locale('zh'), child: Text(l10n.languageZh)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              tooltip: l10n.mediaLibrary,
              onPressed: () => context.push(AppRoutes.media),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: l10n.settings,
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const HomeSkeleton()
          : _categories.isEmpty
              ? _buildTopicList()
              : CustomScrollView(
                  slivers: [
                    if (widget.parentCategoryId == null)
                      SliverToBoxAdapter(child: _buildDisclaimerBanner(context, l10n)),
                    if (widget.parentCategoryId == null && _continueTopic != null)
                      SliverToBoxAdapter(child: _buildContinueReadingCard(context, _continueTopic!, l10n)),
                    if (widget.parentCategoryId == null && _dailyTopic != null)
                      SliverToBoxAdapter(child: _buildDailyTopicCard(context, _dailyTopic!, l10n, userProvider)),
                    if (widget.parentCategoryId == null)
                      SliverToBoxAdapter(child: _buildDailyQuestionCard(context, l10n)),
                    if (widget.parentCategoryId == null && _seasonInfo != null && _seasonTopics.isNotEmpty)
                      SliverToBoxAdapter(child: _buildSeasonBanner(context, l10n, userProvider)),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildCategoryCard(context, _categories[index], userProvider),
                          childCount: _categories.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSeasonBanner(BuildContext context, AppLocalizations l10n, UserProvider userProvider) {
    final info = _seasonInfo!;
    final isRamadan = info.type == SeasonType.ramadan;
    final isShaaban = info.type == SeasonType.shaaban;
    final isHajj = info.type == SeasonType.hajj;

    final title = isShaaban
        ? l10n.seasonShaaban
        : isRamadan
            ? l10n.seasonRamadan
            : l10n.seasonHajj;
    final subtitle = isShaaban
        ? l10n.seasonShaabanDesc
        : isRamadan
            ? l10n.seasonRamadanDesc
            : l10n.seasonHajjDesc;
    final colors = isHajj
        ? [const Color(0xFFE65100), const Color(0xFFFF8F00)]
        : [const Color(0xFF4A148C), const Color(0xFF7B1FA2)];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(isHajj ? Icons.mosque : Icons.nightlight_round, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  info.hijri.formatted(),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _seasonTopics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final topic = _seasonTopics[index];
                return SizedBox(
                  width: 200,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.push(AppRoutes.topic(topic.id!)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topic.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const Spacer(),
                            Text(l10n.readMore, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBanner(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push(AppRoutes.methodology),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.blue.shade800),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.disclaimerHomeBanner, style: const TextStyle(fontSize: 12, height: 1.3))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueReadingCard(BuildContext context, Topic topic, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.play_circle_outline),
          title: Text(l10n.continueReading),
          subtitle: Text(topic.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push(AppRoutes.topic(topic.id!)),
        ),
      ),
    );
  }

  Widget _buildDailyQuestionCard(BuildContext context, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context);
    final q = DailyQuestionService.questionForToday();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: Colors.indigo.shade50,
        child: ListTile(
          leading: Icon(Icons.quiz, color: Colors.indigo.shade700),
          title: Text(l10n.dailyQuestion, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(q.question(locale), maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuizScreen(singleQuestion: q)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDailyTopicCard(BuildContext context, Topic topic, AppLocalizations l10n, UserProvider userProvider) {
    final theme = Theme.of(context);
    final isArabic = userProvider.locale.languageCode == 'ar';
    final showReminder = userProvider.dailyReminderEnabled && !userProvider.hasReadDailyTopicToday;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () async {
            await userProvider.markDailyTopicRead();
            if (!context.mounted) return;
            context.push(AppRoutes.topic(topic.id!));
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(showReminder ? Icons.notifications_active : Icons.wb_sunny,
                        color: showReminder ? Colors.amberAccent : Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        showReminder ? l10n.dailyReminderBanner : l10n.dailyTopic,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  topic.title,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: isArabic ? 'Amiri' : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                  child: Text(
                    l10n.readMore,
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category, UserProvider userProvider) {
    final colors = CategoryVisuals.gradient(category.icon);
    final asset = CategoryVisuals.assetPath(category.icon, imageUrl: category.imageUrl);

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push(AppRoutes.category(category.id!, name: category.name)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset != null)
              Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.first.withValues(alpha: asset != null ? 0.55 : 1),
                      colors.last.withValues(alpha: asset != null ? 0.92 : 1),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CategoryVisuals.iconData(category.icon), size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: userProvider.locale.languageCode == 'ar' ? 16 : 14,
                        fontFamily: userProvider.locale.languageCode == 'ar' ? 'Amiri' : null,
                        shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 3)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicList() {
    if (widget.parentCategoryId == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noResults));
    }
    return TopicListScreen(
      categoryId: widget.parentCategoryId!,
      categoryName: widget.categoryName!,
    );
  }
}
