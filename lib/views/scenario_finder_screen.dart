import 'package:flutter/material.dart';
import '../data/practical_cases.dart';
import '../l10n/app_localizations.dart';
import 'practical_cases_screen.dart' show PracticalCasePlayScreen;

class ScenarioFinderScreen extends StatefulWidget {
  const ScenarioFinderScreen({super.key});

  @override
  State<ScenarioFinderScreen> createState() => _ScenarioFinderScreenState();
}

class _ScenarioFinderScreenState extends State<ScenarioFinderScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PracticalCase> get _filtered {
    if (_query.trim().isEmpty) return PracticalCases.all;
    final q = _query.toLowerCase();
    return PracticalCases.all.where((c) {
      return c.titleFr.toLowerCase().contains(q) ||
          (c.titleEn?.toLowerCase().contains(q) ?? false) ||
          c.scenarioFr.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final cases = _filtered;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scenarioFinder)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.scenarioFinderHint,
                prefixIcon: const Icon(Icons.psychology),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: cases.isEmpty
                ? Center(child: Text(l10n.noScenariosFound))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = cases[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.help_outline),
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
