import 'package:flutter/material.dart';
import '../models/law.dart';
import '../services/database_helper.dart';
import 'detail_screen.dart';
import '../l10n/app_localizations.dart';

class LawListScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const LawListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: FutureBuilder<List<Law>>(
        future: DatabaseHelper().getLawsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.noLaws));
          }
          final laws = snapshot.data!;
          return ListView.builder(
            itemCount: laws.length,
            itemBuilder: (context, index) {
              final law = laws[index];
              return ListTile(
                title: Text(law.title),
                subtitle: Text(law.school),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailScreen(law: law)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
