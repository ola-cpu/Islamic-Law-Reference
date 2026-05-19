import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../services/database_helper.dart';
import 'detail_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class TopicListScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const TopicListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder<List<Topic>>(
      future: DatabaseHelper().getTopicsByCategory(categoryId, locale: userProvider.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(l10n.noLaws));
        }
        final topics = snapshot.data!;
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return ListTile(
              title: Text(topic.title),
              subtitle: Text(topic.description),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(topic: topic)),
                );
              },
            );
          },
        );
      },
    );
  }
}
