import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/school.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../data/school_constants.dart';

class SchoolComparisonScreen extends StatefulWidget {
  final Topic topic;

  const SchoolComparisonScreen({super.key, required this.topic});

  @override
  State<SchoolComparisonScreen> createState() => _SchoolComparisonScreenState();
}

class _SchoolComparisonScreenState extends State<SchoolComparisonScreen> {
  late Future<List<Law>> _lawsFuture;

  @override
  void initState() {
    super.initState();
    final locale = Provider.of<UserProvider>(context, listen: false).locale;
    _lawsFuture = DatabaseHelper().getLawsByTopic(widget.topic.id!, locale: locale);
    Provider.of<UserProvider>(context, listen: false).recordComparisonViewed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context);
    final preferred = user.preferredSchool;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.compareSchools)),
      body: FutureBuilder<List<Law>>(
        future: _lawsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final laws = snapshot.data ?? [];
          if (laws.length < 2) {
            return Center(child: Text(l10n.noComparisonAvailable));
          }

          laws.sort((a, b) {
            if (preferred == null) return 0;
            return _isPreferred(b, preferred).compareTo(_isPreferred(a, preferred));
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(widget.topic.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.topic.description, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 20),
              ...laws.map((law) => _LawCompareCard(law: law, l10n: l10n, preferredSlug: preferred)),
            ],
          );
        },
      ),
    );
  }

  bool _isPreferred(Law law, String slug) {
    final title = law.title.toLowerCase();
    switch (slug) {
      case SchoolSlugs.hanafi:
        return title.contains('hanafi');
      case SchoolSlugs.maliki:
        return title.contains('maliki');
      case SchoolSlugs.shafii:
        return title.contains('shafi');
      case SchoolSlugs.hanbali:
        return title.contains('hanbali');
      case SchoolSlugs.jafari:
        return title.contains('ja\'fari') || title.contains('jafari');
      default:
        return false;
    }
  }
}

class _LawCompareCard extends StatelessWidget {
  final Law law;
  final AppLocalizations l10n;
  final String? preferredSlug;

  const _LawCompareCard({required this.law, required this.l10n, this.preferredSlug});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<School?>(
      future: DatabaseHelper().getSchoolById(law.schoolId),
      builder: (context, snap) {
        final schoolName = snap.data?.name ?? law.title;
        final isPreferred = preferredSlug != null && SchoolSlugs.fromDbName(schoolName) == preferredSlug;
        final color = _schoolColor(schoolName);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isPreferred ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isPreferred ? color : color.withValues(alpha: 0.3), width: isPreferred ? 2 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        _localizedSchool(schoolName, l10n),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    if (isPreferred) ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(l10n.myMadhhabLabel, style: const TextStyle(fontSize: 10)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                if (law.contentAr != null) ...[
                  Text(
                    law.contentAr!,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 18, height: 1.6),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(law.content, style: const TextStyle(fontSize: 15, height: 1.6)),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _schoolColor(String? name) {
    switch (name) {
      case 'Hanafi':
        return Colors.blue;
      case 'Maliki':
        return Colors.green;
      case 'Shafi\'i':
        return Colors.orange;
      case 'Hanbali':
        return Colors.red;
      case 'Ja\'fari':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _localizedSchool(String? name, AppLocalizations l10n) {
    switch (name) {
      case 'Hanafi':
        return l10n.schoolHanafi;
      case 'Maliki':
        return l10n.schoolMaliki;
      case 'Shafi\'i':
        return l10n.schoolShafii;
      case 'Hanbali':
        return l10n.schoolHanbali;
      case 'Ja\'fari':
        return l10n.schoolJafari;
      default:
        return name ?? '';
    }
  }
}
