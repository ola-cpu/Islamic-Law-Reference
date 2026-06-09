import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class MethodologyScreen extends StatefulWidget {
  const MethodologyScreen({super.key});

  @override
  State<MethodologyScreen> createState() => _MethodologyScreenState();
}

class _MethodologyScreenState extends State<MethodologyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).recordMethodologyViewed();
    });
  }

  static const _scholarLinks = [
    ('SeekersGuidance', 'https://seekersguidance.org/'),
    ('IslamQA', 'https://islamqa.info/'),
    ('Dar al-Ifta', 'https://www.dar-alifta.org/'),
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.methodology)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(Icons.verified_user, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(l10n.methodologyTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(l10n.methodologyBody, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 24),
          Text(l10n.methodologySources, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(l10n.methodologySourcesBody, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 24),
          Text(l10n.askScholar, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(l10n.askScholarDesc, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
          const SizedBox(height: 12),
          ..._scholarLinks.map((link) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: Text(link.$1),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _openUrl(link.$2),
                ),
              )),
          const SizedBox(height: 16),
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber, color: Colors.amber.shade800),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.disclaimerGeneral, style: const TextStyle(height: 1.5))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
