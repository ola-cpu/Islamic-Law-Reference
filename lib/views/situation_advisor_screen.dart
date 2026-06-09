import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../l10n/app_localizations.dart';
import '../services/situation_matcher_service.dart';
import 'practical_cases_screen.dart' show PracticalCasePlayScreen;

class SituationAdvisorScreen extends StatefulWidget {
  const SituationAdvisorScreen({super.key});

  @override
  State<SituationAdvisorScreen> createState() => _SituationAdvisorScreenState();
}

class _SituationAdvisorScreenState extends State<SituationAdvisorScreen> {
  final _controller = TextEditingController();
  List<SituationMatch> _matches = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _loading = true;
      _searched = true;
    });
    final locale = Localizations.localeOf(context);
    final results = await SituationMatcherService.match(query, locale: locale);
    if (mounted) {
      setState(() {
        _matches = results;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.situationAdvisor)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.situationAdvisorDesc, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.situationAdvisorHint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSubmitted: (_) => _search(),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _loading ? null : _search,
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.search),
                  label: Text(l10n.analyzeSituation),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : !_searched
                    ? Center(child: Text(l10n.situationAdvisorEmpty, style: TextStyle(color: Colors.grey.shade600)))
                    : _matches.isEmpty
                        ? Center(child: Text(l10n.noSituationMatches))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _matches.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final match = _matches[index];
                              if (match.topic != null) {
                                final t = match.topic!;
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.menu_book),
                                    title: Text(t.title),
                                    subtitle: Text(t.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () => context.push(AppRoutes.topic(t.id!)),
                                  ),
                                );
                              }
                              final c = match.practicalCase!;
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.psychology),
                                  title: Text(c.title(locale)),
                                  subtitle: Text(c.scenario(locale), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => PracticalCasePlayScreen(caseData: c)),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
