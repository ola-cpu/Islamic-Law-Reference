import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/learning_content.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;

  List<QuizQuestion> get _questions => LearningContent.quizQuestions;

  void _select(int optionIndex) {
    if (_answered) return;
    setState(() {
      _selected = optionIndex;
      _answered = true;
      if (optionIndex == _questions[_index].correctIndex) _score++;
    });
  }

  void _next() {
    if (_index >= _questions.length - 1) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  Future<void> _finish() async {
    final percent = ((_score / _questions.length) * 100).round();
    await Provider.of<UserProvider>(context, listen: false).recordQuizScore(percent);
    setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    if (_finished) {
      final percent = ((_score / _questions.length) * 100).round();
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quizResults)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  percent >= 70 ? Icons.emoji_events : Icons.school,
                  size: 72,
                  color: percent >= 70 ? Colors.amber : theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(l10n.quizScore(_score, _questions.length), style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('$percent%', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                const SizedBox(height: 8),
                Text(
                  percent >= 70 ? l10n.quizPassed : l10n.quizTryAgain,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_index];
    final options = q.options(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quiz),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_index + 1}/${_questions.length}')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_index + 1) / _questions.length, minHeight: 6, borderRadius: BorderRadius.circular(3)),
            const SizedBox(height: 24),
            Text(q.question(locale), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...List.generate(options.length, (i) {
              final isCorrect = i == q.correctIndex;
              Color? bg;
              if (_answered) {
                if (isCorrect) {
                  bg = Colors.green.withValues(alpha: 0.15);
                } else if (_selected == i) {
                  bg = Colors.red.withValues(alpha: 0.15);
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: bg ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: CircleAvatar(
                      radius: 14,
                      child: Text(String.fromCharCode(65 + i), style: const TextStyle(fontSize: 12)),
                    ),
                    title: Text(options[i]),
                    trailing: _answered && isCorrect
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : _answered && _selected == i
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null,
                    onTap: () => _select(i),
                  ),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 12),
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(q.explanation(locale)),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _next,
                child: Text(_index >= _questions.length - 1 ? l10n.finish : l10n.nextQuestion),
              ),
            ] else
              const Spacer(),
          ],
        ),
      ),
    );
  }
}
