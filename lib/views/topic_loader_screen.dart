import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/database_helper.dart';
import 'detail_screen.dart';

/// Charge un sujet par ID — utilisé pour les deep links `/topic/:id`.
class TopicLoaderScreen extends StatefulWidget {
  final int topicId;

  const TopicLoaderScreen({super.key, required this.topicId});

  @override
  State<TopicLoaderScreen> createState() => _TopicLoaderScreenState();
}

class _TopicLoaderScreenState extends State<TopicLoaderScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<UserProvider>(context, listen: false).locale;

    return FutureBuilder(
      future: DatabaseHelper().getTopicById(widget.topicId, locale: locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final topic = snapshot.data;
        if (topic == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Sujet introuvable')),
          );
        }
        return DetailScreen(topic: topic);
      },
    );
  }
}
