import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import 'package:provider/provider.dart';
import '../data/guided_courses.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.guidedCourses)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.guidedCoursesDesc, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          ...GuidedCourses.all.map((course) {
            final completed = userProvider.getCourseCompletedDays(course.id).length;
            final total = course.days.length;
            final progress = completed / total;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(course.icon, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(course.title(locale)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.description(locale)),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: progress, minHeight: 4, borderRadius: BorderRadius.circular(2)),
                    const SizedBox(height: 4),
                    Text(l10n.courseProgress(completed, total), style: const TextStyle(fontSize: 11)),
                  ],
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.push(AppRoutes.course(course.id));
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
