import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class DetailScreen extends StatefulWidget {
  final Law law;

  const DetailScreen({super.key, required this.law});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  late Future<List<Source>> _sourcesFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _noteController.text = userProvider.getNote(widget.law.id!) ?? '';
    _sourcesFuture = DatabaseHelper().getSourcesByLaw(widget.law.id!);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.law.title),
        actions: [
          IconButton(
            icon: Icon(
              userProvider.isFavorite(widget.law.id!) ? Icons.favorite : Icons.favorite_border,
              color: userProvider.isFavorite(widget.law.id!) ? Colors.red : null,
            ),
            onPressed: () {
              userProvider.toggleFavorite(widget.law.id!);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.law.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sources,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            FutureBuilder<List<Source>>(
              future: _sourcesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(l10n.noSources);
                }
                return Column(
                  children: snapshot.data!.map((source) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source.reference,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              source.text,
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            if (widget.law.scholarComments != null && widget.law.scholarComments!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                l10n.comments,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Text(widget.law.scholarComments!),
            ],
            const SizedBox(height: 20),
            Text(
              '${l10n.school} ${widget.law.school}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              l10n.personalNotes,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.addNoteHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                userProvider.addNote(widget.law.id!, _noteController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.noteSaved)),
                );
              },
              child: Text(l10n.saveNote),
            ),
          ],
        ),
      ),
    );
  }
}
