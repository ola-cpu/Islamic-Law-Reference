import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/learning_content.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../services/adaptive_quiz_service.dart';

class QuizScreen extends StatefulWidget {
  final bool examMode;
  final QuizQuestion? singleQuestion;

  const QuizScreen({super.key, this.examMode = false, this.singleQuestion});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;
  final Map<int, int> _examAnswers = {};
  List<QuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    if (widget.singleQuestion != null) {
      _questions = [widget.singleQuestion!];
    } else {
      _questions = await AdaptiveQuizService.orderedQuestions();
    }
    if (mounted) setState(() {});
  }

  Future<void> _select(int optionIndex) async {
    if (_answered && !widget.examMode) return;
    if (widget.examMode) {
      setState(() {
        _selected = optionIndex;
        _examAnswers[_index] = optionIndex;
      });
      return;
    }
    final q = _questions[_index];
    final correct = optionIndex == q.correctIndex;
    if (correct) {
      await AdaptiveQuizService.recordCorrect(AdaptiveQuizService.questionKey(q));
    } else {
      await AdaptiveQuizService.recordMistake(AdaptiveQuizService.questionKey(q));
    }
    setState(() {
      _selected = optionIndex;
      _answered = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (widget.examMode) {
      if (_selected == null) return;
      if (_index >= _questions.length - 1) {
        _finishExam();
        return;
      }
      setState(() {
        _index++;
        _selected = _examAnswers[_index];
      });
      return;
    }
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

  Future<void> _finishExam() async {
    var score = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_examAnswers[i] == _questions[i].correctIndex) score++;
    }
    _score = score;
    final percent = ((_score / _questions.length) * 100).round();
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.recordQuizScore(percent);
    await user.recordExamScore(percent);
    setState(() => _finished = true);
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

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quiz)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                if (widget.examMode) ...[
                  const SizedBox(height: 16),
                  ...List.generate(_questions.length, (i) {
                    final q = _questions[i];
                    final ok = _examAnswers[i] == q.correctIndex;
                    return ListTile(
                      dense: true,
                      leading: Icon(ok ? Icons.check : Icons.close, color: ok ? Colors.green : Colors.red),
                      title: Text(q.question(locale), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(q.explanation(locale), maxLines: 2, overflow: TextOverflow.ellipsis),
                    );
                  }),
                ],
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
    final showFeedback = _answered && !widget.examMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examMode ? l10n.examMode : l10n.quiz),
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
              if (showFeedback) {
                if (isCorrect) {
                  bg = Colors.green.withValues(alpha: 0.15);
                } else if (_selected == i) {
                  bg = Colors.red.withValues(alpha: 0.15);
                }
              } else if (widget.examMode && _selected == i) {
                bg = theme.colorScheme.primaryContainer.withValues(alpha: 0.5);
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
                    trailing: showFeedback && isCorrect
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : showFeedback && _selected == i
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null,
                    onTap: () => _select(i),
                  ),
                ),
              );
            }),
            if (showFeedback) ...[
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
            ] else if (widget.examMode || widget.singleQuestion != null) ...[
              const Spacer(),
              FilledButton(
                onPressed: _selected == null ? null : _next,
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
