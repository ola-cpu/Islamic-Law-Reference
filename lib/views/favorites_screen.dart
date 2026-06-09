import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../router/app_router.dart';
import '../models/topic.dart';
import '../models/badge.dart';
import '../providers/user_provider.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../services/export_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late TabController _tabController;
  int _topicCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTopicCount();
  }

  Future<void> _loadTopicCount() async {
    final count = await _dbHelper.getTopicCount();
    if (mounted) setState(() => _topicCount = count);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showExportMenu(
    BuildContext context,
    UserProvider user,
    AppLocalizations l10n,
  ) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: Text(l10n.exportAsText),
              onTap: () => Navigator.pop(context, 'text'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(l10n.exportAsPdf),
              onTap: () => Navigator.pop(context, 'pdf'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || choice == null) return;

    if (choice == 'text') {
      final text = await ExportService.buildLibraryExport(
        user: user,
        appTitle: l10n.appTitle,
        favoritesLabel: l10n.favorites,
        notesLabel: l10n.personalNotes,
        noneLabel: l10n.noneLabel,
      );
      await SharePlus.instance.share(ShareParams(text: text));
    } else if (choice == 'pdf') {
      final bytes = await ExportService.buildLibraryPdfBytes(
        user: user,
        appTitle: l10n.appTitle,
        favoritesLabel: l10n.favorites,
        notesLabel: l10n.personalNotes,
        noneLabel: l10n.noneLabel,
      );
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(Uint8List.fromList(bytes), name: 'library_export.pdf', mimeType: 'application/pdf')],
      ));
    }
    await user.recordShare();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myLibrary),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: l10n.dashboard,
            onPressed: () => context.push(AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: l10n.exportLibrary,
            onPressed: () => _showExportMenu(context, userProvider, l10n),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.favorite), text: l10n.favorites),
            Tab(icon: const Icon(Icons.history), text: l10n.readingHistory),
            Tab(icon: const Icon(Icons.emoji_events), text: l10n.badges),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_topicCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Text(
                l10n.topicsExplored(userProvider.uniqueTopicsRead, _topicCount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TopicListTab(
                  topicIds: userProvider.favorites,
                  emptyMessage: l10n.noFavorites,
                  locale: userProvider.locale,
                ),
                _TopicListTab(
                  topicIds: userProvider.readingHistoryIds,
                  emptyMessage: l10n.noHistory,
                  locale: userProvider.locale,
                  showReadDate: true,
                  readDates: {
                    for (final e in userProvider.readingHistory) e.topicId: e.readAt,
                  },
                ),
                _BadgesTab(userProvider: userProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicListTab extends StatelessWidget {
  final List<int> topicIds;
  final String emptyMessage;
  final Locale locale;
  final bool showReadDate;
  final Map<int, DateTime> readDates;

  const _TopicListTab({
    required this.topicIds,
    required this.emptyMessage,
    required this.locale,
    this.showReadDate = false,
    this.readDates = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (topicIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(emptyMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<Topic>>(
      future: DatabaseHelper().getTopicsByIds(topicIds, locale: locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final topics = snapshot.data ?? [];
        if (topics.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        final ordered = <Topic>[];
        for (final id in topicIds) {
          for (final topic in topics) {
            if (topic.id == id) {
              ordered.add(topic);
              break;
            }
          }
        }

        return ListView.builder(
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            final topic = ordered[index];
            final readAt = readDates[topic.id];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text('${index + 1}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
              title: Text(topic.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (showReadDate && readAt != null)
                    Text(
                      _formatDate(readAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(AppRoutes.topic(topic.id!));
              },
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _BadgesTab extends StatelessWidget {
  final UserProvider userProvider;

  const _BadgesTab({required this.userProvider});

  String _badgeTitle(BadgeDefinition badge, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return badge.titleEn ?? badge.titleFr;
      case 'ar':
        return badge.titleAr ?? badge.titleFr;
      default:
        return badge.titleFr;
    }
  }

  String _badgeDesc(BadgeDefinition badge, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return badge.descEn ?? badge.descFr;
      case 'ar':
        return badge.descAr ?? badge.descFr;
      default:
        return badge.descFr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = userProvider.locale;
    final unlocked = userProvider.unlockedBadgeKeys.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.badgesProgress(unlocked, BadgeCatalog.all.length),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...BadgeCatalog.all.map((badge) {
          final isUnlocked = userProvider.hasBadge(badge.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: isUnlocked
                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
                : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isUnlocked ? Colors.amber : Colors.grey.shade300,
                child: Icon(
                  badge.icon,
                  color: isUnlocked ? Colors.brown.shade800 : Colors.grey.shade600,
                ),
              ),
              title: Text(
                _badgeTitle(badge, locale),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? null : Colors.grey.shade600,
                ),
              ),
              subtitle: Text(_badgeDesc(badge, locale)),
              trailing: Icon(
                isUnlocked ? Icons.check_circle : Icons.lock_outline,
                color: isUnlocked ? Colors.green : Colors.grey,
              ),
            ),
          );
        }),
      ],
    );
  }
}
