import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../router/app_router.dart';
import '../data/guided_courses.dart';
import '../models/topic.dart';
import '../providers/user_provider.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';

class CourseDetailScreen extends StatefulWidget {
  final GuidedCourse course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  Map<String, Topic?> _topicsByTitle = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final map = <String, Topic?>{};
    for (final day in widget.course.days) {
      map[day.topicTitleFr] = await _db.getTopicByTitle(day.topicTitleFr, locale: userProvider.locale);
    }
    if (mounted) setState(() {
      _topicsByTitle = map;
      _loading = false;
    });
  }

  Future<void> _openDay(CourseDay day, int dayIndex) async {
    final topic = _topicsByTitle[day.topicTitleFr];
    if (topic == null) return;
    await context.push(AppRoutes.topic(topic.id!));
    if (!mounted) return;
    await Provider.of<UserProvider>(context, listen: false)
        .markCourseDayComplete(widget.course.id, dayIndex, totalDays: widget.course.days.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final userProvider = Provider.of<UserProvider>(context);
    final completed = userProvider.getCourseCompletedDays(widget.course.id);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.course.title(locale))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final allDone = completed.length >= widget.course.days.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title(locale))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.course.description(locale), style: TextStyle(color: Colors.grey.shade700)),
          if (allDone) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.amber.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.courseComplete, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...widget.course.days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isDone = completed.contains(index);
            final topic = _topicsByTitle[day.topicTitleFr];
            final locked = index > 0 && !completed.contains(index - 1);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDone
                      ? Colors.green
                      : locked
                          ? Colors.grey.shade300
                          : Theme.of(context).colorScheme.primary,
                  child: Icon(
                    isDone ? Icons.check : locked ? Icons.lock : Icons.circle,
                    color: Colors.white,
                    size: isDone || locked ? 20 : 12,
                  ),
                ),
                title: Text(day.title(locale)),
                subtitle: Text(day.summary(locale)),
                isThreeLine: true,
                enabled: !locked && topic != null,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: locked || topic == null ? null : () => _openDay(day, index),
              ),
            );
          }),
        ],
      ),
    );
  }
}
