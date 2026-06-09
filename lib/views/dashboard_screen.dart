import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';

import '../providers/user_provider.dart';

import '../models/topic.dart';
import '../services/export_service.dart';

import '../data/guided_courses.dart';

import '../router/app_router.dart';



class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});



  @override

  State<DashboardScreen> createState() => _DashboardScreenState();

}



class _DashboardScreenState extends State<DashboardScreen> {

  DashboardStats? _stats;

  Topic? _suggestedTopic;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final user = Provider.of<UserProvider>(context, listen: false);

    final stats = await DashboardStats.load(user);

    final topic = await user.getSuggestedTopic();

    if (mounted) {

      setState(() {

        _stats = stats;

        _suggestedTopic = topic;

      });

    }

  }



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final user = Provider.of<UserProvider>(context);

    final theme = Theme.of(context);



    if (_stats == null) {

      return Scaffold(

        appBar: AppBar(title: Text(l10n.dashboard)),

        body: const Center(child: CircularProgressIndicator()),

      );

    }



    final s = _stats!;



    return Scaffold(

      appBar: AppBar(title: Text(l10n.dashboard)),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          if (user.readingStreak > 0)

            Card(

              color: Colors.orange.shade50,

              margin: const EdgeInsets.only(bottom: 16),

              child: ListTile(

                leading: Icon(Icons.local_fire_department, color: Colors.orange.shade800, size: 32),

                title: Text(l10n.readingStreak(user.readingStreak),

                    style: const TextStyle(fontWeight: FontWeight.bold)),

                subtitle: Text(l10n.readingStreakDesc),

              ),

            ),

          if (_suggestedTopic != null) ...[
            Text(l10n.suggestedTopic, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(_suggestedTopic!.title),
                subtitle: Text(_suggestedTopic!.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.push(AppRoutes.topic(_suggestedTopic!.id!)),
              ),
            ),
          ],

          Card(

            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [

                  Icon(Icons.insights, size: 48, color: theme.colorScheme.primary),

                  const SizedBox(height: 12),

                  Text(

                    l10n.explorationLevel((s.explorationPercent * 100).round()),

                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),

                  ),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(

                    value: s.explorationPercent,

                    minHeight: 8,

                    borderRadius: BorderRadius.circular(4),

                  ),

                  const SizedBox(height: 4),

                  Text(l10n.topicsExplored(s.topicsRead, s.topicCount)),

                ],

              ),

            ),

          ),

          const SizedBox(height: 16),

          _StatRow(icon: Icons.favorite, label: l10n.favorites, value: '${s.favoritesCount}'),

          _StatRow(icon: Icons.note, label: l10n.personalNotes, value: '${s.notesCount}'),

          _StatRow(

            icon: Icons.emoji_events,

            label: l10n.badges,

            value: '${s.badgesUnlocked}/${s.badgesTotal}',

          ),

          _StatRow(

            icon: Icons.route,

            label: l10n.guidedCourses,

            value: l10n.coursesCompleted(s.coursesCompleted, GuidedCourses.all.length),

          ),

          const SizedBox(height: 24),

          Text(l10n.courseProgressTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          ...GuidedCourses.all.map((course) {

            final done = user.getCourseCompletedDays(course.id).length;

            final total = course.days.length;

            return Padding(

              padding: const EdgeInsets.only(bottom: 8),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(course.title(user.locale), style: const TextStyle(fontWeight: FontWeight.w500)),

                  const SizedBox(height: 4),

                  LinearProgressIndicator(

                    value: total == 0 ? 0 : done / total,

                    minHeight: 6,

                    borderRadius: BorderRadius.circular(3),

                  ),

                  Text(l10n.courseProgress(done, total), style: const TextStyle(fontSize: 11)),

                ],

              ),

            );

          }),

        ],

      ),

    );

  }

}



class TopicSuggestion {

  final dynamic topic;

  TopicSuggestion(this.topic);

}



class _StatRow extends StatelessWidget {

  final IconData icon;

  final String label;

  final String value;



  const _StatRow({required this.icon, required this.label, required this.value});



  @override

  Widget build(BuildContext context) {

    return ListTile(

      leading: CircleAvatar(

        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,

        child: Icon(icon, size: 20),

      ),

      title: Text(label),

      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

    );

  }

}

