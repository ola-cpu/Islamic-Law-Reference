import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../models/school.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class DetailScreen extends StatefulWidget {
  final Topic topic;

  const DetailScreen({super.key, required this.topic});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  late Future<List<Law>> _lawsFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _noteController.text = userProvider.getNote(widget.topic.id!) ?? '';
    _lawsFuture = DatabaseHelper().getLawsByTopic(widget.topic.id!);
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
        title: Text(widget.topic.title),
        actions: [
          IconButton(
            icon: Icon(
              userProvider.isFavorite(widget.topic.id!) ? Icons.favorite : Icons.favorite_border,
              color: userProvider.isFavorite(widget.topic.id!) ? Colors.red : null,
            ),
            onPressed: () {
              userProvider.toggleFavorite(widget.topic.id!);
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
              widget.topic.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Law>>(
              future: _lawsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(l10n.noLaws);
                }
                return Column(
                  children: snapshot.data!.map((law) => _buildLawCard(law, l10n)).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
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
                userProvider.addNote(widget.topic.id!, _noteController.text);
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

  Widget _buildLawCard(Law law, AppLocalizations l10n) {
    return FutureBuilder<School?>(
      future: DatabaseHelper().getSchoolById(law.schoolId),
      builder: (context, schoolSnapshot) {
        final schoolName = schoolSnapshot.data?.name ?? "...";
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      schoolName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                    ),
                    const Icon(Icons.gavel, color: Colors.green),
                  ],
                ),
                const Divider(),
                if (law.contentAr != null) ...[
                  Text(
                    law.contentAr!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arabic'),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                ],
                Text(law.content),
                const SizedBox(height: 16),
                Text(
                  l10n.sources,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildSourcesList(law.id!, l10n),
                if (law.scholarComments != null && law.scholarComments!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.comments,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(law.scholarComments!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourcesList(int lawId, AppLocalizations l10n) {
    return FutureBuilder<List<Source>>(
      future: DatabaseHelper().getSourcesByLaw(lawId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(l10n.noSources);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.data!.map((source) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${source.reference} (${_getAuthenticityLabel(source.authenticity)})",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  if (source.textAr != null)
                    Text(
                      source.textAr!,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Arabic'),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  Text(
                    source.text,
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  if (source.citation != null)
                    Text(
                      "Ref: ${source.citation}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _getAuthenticityLabel(Authenticity authenticity) {
    switch (authenticity) {
      case Authenticity.sahih: return "Sahih";
      case Authenticity.hasan: return "Hasan";
      case Authenticity.daif: return "Da'if";
      case Authenticity.mawdu: return "Mawdu'";
      default: return "";
    }
  }
}
