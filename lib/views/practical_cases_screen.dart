import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/practical_cases.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class PracticalCasesScreen extends StatelessWidget {
  const PracticalCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.practicalCases)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.practicalCasesDesc, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          ...PracticalCases.all.map((c) {
            final done = user.isPracticalCaseCompleted(c.id);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: done
                      ? Colors.green.shade100
                      : Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(c.icon, color: done ? Colors.green.shade800 : Theme.of(context).colorScheme.primary),
                ),
                title: Text(c.title(locale)),
                subtitle: Text(done ? l10n.caseCompleted : l10n.casePending),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticalCasePlayScreen(caseData: c)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PracticalCasePlayScreen extends StatefulWidget {
  final PracticalCase caseData;

  const PracticalCasePlayScreen({super.key, required this.caseData});

  @override
  State<PracticalCasePlayScreen> createState() => _PracticalCasePlayScreenState();
}

class _PracticalCasePlayScreenState extends State<PracticalCasePlayScreen> {
  int? _selected;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final c = widget.caseData;
    final options = c.options(locale);

    return Scaffold(
      appBar: AppBar(title: Text(c.title(locale))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(c.scenario(locale), style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.chooseAnswer, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(options.length, (i) {
            final isCorrect = i == c.correctIndex;
            Color? tileColor;
            if (_revealed && _selected == i) {
              tileColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
            }
            return Card(
              color: tileColor,
              margin: const EdgeInsets.only(bottom: 8),
              child: RadioListTile<int>(
                title: Text(options[i]),
                value: i,
                groupValue: _selected,
                onChanged: _revealed
                    ? null
                    : (v) => setState(() => _selected = v),
              ),
            );
          }),
          if (!_revealed)
            FilledButton(
              onPressed: _selected == null
                  ? null
                  : () => setState(() => _revealed = true),
              child: Text(l10n.checkAnswer),
            ),
          if (_revealed) ...[
            const SizedBox(height: 16),
            Icon(
              _selected == c.correctIndex ? Icons.check_circle : Icons.info,
              color: _selected == c.correctIndex ? Colors.green : Colors.orange,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              _selected == c.correctIndex ? l10n.correctAnswer : l10n.wrongAnswer,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(c.explanation(locale)),
            const SizedBox(height: 20),
            Text(l10n.schoolPositions, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...c.schoolRulings.map((r) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_schoolLabel(l10n, r.schoolSlug)),
                    subtitle: Text(r.ruling(locale)),
                  ),
                )),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .recordPracticalCaseCompleted(c.id);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.finishCase),
            ),
          ],
        ],
      ),
    );
  }

  String _schoolLabel(AppLocalizations l10n, String slug) {
    switch (slug) {
      case 'hanafi':
        return l10n.schoolHanafi;
      case 'maliki':
        return l10n.schoolMaliki;
      case 'shafii':
        return l10n.schoolShafii;
      case 'hanbali':
        return l10n.schoolHanbali;
      case 'jafari':
        return l10n.schoolJafari;
      default:
        return slug;
    }
  }
}
