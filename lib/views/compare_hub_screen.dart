import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import 'school_comparison_screen.dart';

class CompareHubScreen extends StatefulWidget {
  const CompareHubScreen({super.key});

  @override
  State<CompareHubScreen> createState() => _CompareHubScreenState();
}

class _CompareHubScreenState extends State<CompareHubScreen> {
  late Future<List<Topic>> _topicsFuture;
  bool _consensusOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _topicsFuture = DatabaseHelper()
        .getTopicsWithComparisons(locale: userProvider.locale, consensusOnly: _consensusOnly)
        .then((topics) => userProvider.filterTopicsByMadhhab(topics));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.compareSchools)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: FilterChip(
              label: Text(l10n.consensusOnly),
              selected: _consensusOnly,
              onSelected: (v) => setState(() {
                _consensusOnly = v;
                _load();
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Topic>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snapshot.data ?? [];
          if (topics.isEmpty) {
            return Center(child: Text(l10n.noComparisonAvailable));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.compare_arrows, size: 20)),
                  title: Text(topic.title),
                  subtitle: Text(topic.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SchoolComparisonScreen(topic: topic)),
                    );
                  },
                ),
              );
            },
          );
        },
            ),
          ),
        ],
      ),
    );
  }
}
