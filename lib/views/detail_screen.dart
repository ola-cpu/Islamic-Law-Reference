import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../models/school.dart';
import '../models/media_item.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import 'hajj_timeline.dart';

class DetailScreen extends StatefulWidget {
  final Topic topic;

  const DetailScreen({super.key, required this.topic});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  late Future<List<Law>> _lawsFuture;
  late Future<List<MediaItem>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _noteController.text = userProvider.getNote(widget.topic.id!) ?? '';
    _lawsFuture = DatabaseHelper().getLawsByTopic(widget.topic.id!, locale: userProvider.locale);
    _mediaFuture = DatabaseHelper().getMediaForTopic(widget.topic.id!);
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
    final theme = Theme.of(context);

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
            Card(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.topic.description,
                  textAlign: userProvider.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
                  textDirection: userProvider.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: userProvider.locale.languageCode == 'ar' ? FontStyle.normal : FontStyle.italic,
                    fontFamily: userProvider.locale.languageCode == 'ar' ? 'Amiri' : null,
                    fontSize: userProvider.locale.languageCode == 'ar' ? 18 : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildMediaSection(l10n),
            const SizedBox(height: 20),
            if (widget.topic.title.toLowerCase().contains('hajj') || widget.topic.title.toLowerCase().contains('pèlerinage') || widget.topic.title.toLowerCase().contains('pilgrimage')) ...[
               const HajjTimeline(),
               const SizedBox(height: 20),
            ],
            _buildComparisonToggle(l10n),
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
              textAlign: userProvider.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: userProvider.locale.languageCode == 'ar' ? 'Amiri' : null,
              ),
            ),
            const Divider(),
            TextField(
              controller: _noteController,
              maxLines: 3,
              textAlign: userProvider.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
              textDirection: userProvider.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                hintText: l10n.addNoteHint,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () {
                  userProvider.addNote(widget.topic.id!, _noteController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.noteSaved)),
                  );
                },
                label: Text(l10n.saveNote),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonToggle(AppLocalizations l10n) {
    return FutureBuilder<List<Law>>(
      future: _lawsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.length < 2) return const SizedBox.shrink();
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          child: ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: Text(l10n.comparisonTable),
            subtitle: Text(l10n.legalOpinion),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComparisonDialog(context, snapshot.data!, l10n),
          ),
        );
      },
    );
  }

  void _showComparisonDialog(BuildContext context, List<Law> laws, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                Text(
                  l10n.comparisonTable,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: FutureBuilder<Map<int, School>>(
                        future: _getSchoolsMap(laws),
                        builder: (context, schoolMapSnapshot) {
                          if (!schoolMapSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                          final schools = schoolMapSnapshot.data!;
                          return DataTable(
                            columnSpacing: 24,
                            columns: [
                              DataColumn(label: Text(l10n.schoolTitle)),
                              DataColumn(label: Text(l10n.legalOpinion)),
                            ],
                            rows: laws.map((law) {
                              final school = schools[law.schoolId];
                              final color = _getSchoolColor(school?.name);
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: color),
                                      ),
                                      child: Text(
                                        _getLocalizedSchoolName(school?.name, l10n),
                                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          law.content,
                                          style: const TextStyle(fontSize: 13),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Map<int, School>> _getSchoolsMap(List<Law> laws) async {
    final Map<int, School> map = {};
    for (var law in laws) {
      if (!map.containsKey(law.schoolId)) {
        final school = await DatabaseHelper().getSchoolById(law.schoolId);
        if (school != null) map[law.schoolId] = school;
      }
    }
    return map;
  }

  Widget _buildMediaSection(AppLocalizations l10n) {
    return FutureBuilder<List<MediaItem>>(
      future: _mediaFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If no specific media for topic, show a placeholder diagram for certain categories
          if (widget.topic.title.contains('Héritage') || widget.topic.title.contains('succession') || widget.topic.title.contains('Inheritance')) {
             return _buildPlaceholderDiagram(l10n.illustration, Icons.account_tree, l10n);
          }
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.mediaSectionTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...snapshot.data!.map((media) => _buildMediaWidget(media, l10n)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildMediaWidget(MediaItem media, AppLocalizations l10n) {
     return Card(
       clipBehavior: Clip.antiAlias,
       child: Column(
         children: [
           if (media.type == MediaType.image || media.type == MediaType.infographic)
             Image.network(media.url, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50)),
           ListTile(
             title: Text(media.title ?? l10n.illustration),
             subtitle: media.description != null ? Text(media.description!) : null,
             leading: Icon(_getMediaIcon(media.type)),
           ),
         ],
       ),
     );
  }

  IconData _getMediaIcon(MediaType type) {
    switch (type) {
      case MediaType.image: return Icons.image;
      case MediaType.audio: return Icons.audiotrack;
      case MediaType.video: return Icons.videocam;
      case MediaType.infographic: return Icons.assessment;
    }
  }

  Widget _buildPlaceholderDiagram(String title, IconData icon, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Colors.blueGrey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey.withOpacity(0.2)),
      ),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
            Text("(${l10n.comingSoon})", style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _getSchoolColor(String? schoolName) {
    switch (schoolName) {
      case 'Hanafi': return Colors.blue;
      case 'Maliki': return Colors.green;
      case 'Shafi\'i': return Colors.teal;
      case 'Hanbali': return Colors.amber;
      case 'Ja\'fari': return Colors.deepPurple;
      default: return Colors.blueGrey;
    }
  }

  String _getLocalizedSchoolName(String? schoolName, AppLocalizations l10n) {
    switch (schoolName) {
      case 'Hanafi': return l10n.schoolHanafi;
      case 'Maliki': return l10n.schoolMaliki;
      case 'Shafi\'i': return l10n.schoolShafii;
      case 'Hanbali': return l10n.schoolHanbali;
      case 'Ja\'fari': return l10n.schoolJafari;
      default: return schoolName ?? "...";
    }
  }

  Widget _buildLawCard(Law law, AppLocalizations l10n) {
    return FutureBuilder<School?>(
      future: DatabaseHelper().getSchoolById(law.schoolId),
      builder: (context, schoolSnapshot) {
        final schoolName = schoolSnapshot.data?.name;
        final localizedSchoolName = _getLocalizedSchoolName(schoolName, l10n);
        final schoolColor = _getSchoolColor(schoolName);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: schoolColor.withOpacity(0.3), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: schoolColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizedSchoolName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(Icons.gavel, color: schoolColor),
                  ],
                ),
                const SizedBox(height: 16),
                if (law.contentAr != null) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      law.contentAr!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  law.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Text(
                  l10n.sources,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSourcesList(law.id!, l10n),
                if (law.scholarComments != null && law.scholarComments!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(left: BorderSide(color: schoolColor, width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.comments,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(law.scholarComments!, style: const TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
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
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _getAuthenticityBadge(source.authenticity),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source.reference,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                  if (source.textAr != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        source.textAr!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    source.text,
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  if (source.citation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Ref: ${source.citation}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _getAuthenticityBadge(Authenticity authenticity) {
    if (authenticity == Authenticity.none) return const SizedBox.shrink();

    Color color;
    String label;

    switch (authenticity) {
      case Authenticity.sahih:
        color = Colors.green;
        label = "Sahih";
        break;
      case Authenticity.hasan:
        color = Colors.blue;
        label = "Hasan";
        break;
      case Authenticity.daif:
        color = Colors.orange;
        label = "Da'if";
        break;
      case Authenticity.mawdu:
        color = Colors.red;
        label = "Mawdu'";
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
