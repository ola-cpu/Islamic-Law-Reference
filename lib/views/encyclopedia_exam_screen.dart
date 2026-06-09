import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../router/app_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../services/database_helper.dart';
import '../services/topic_srs_service.dart';

class EncyclopediaExamScreen extends StatefulWidget {
  const EncyclopediaExamScreen({super.key});

  @override
  State<EncyclopediaExamScreen> createState() => _EncyclopediaExamScreenState();
}

class _EncyclopediaExamScreenState extends State<EncyclopediaExamScreen> {
  static const _questionCount = 10;
  static const _secondsPerQuestion = 25;

  List<Topic> _topics = [];
  int _index = 0;
  int _known = 0;
  bool _loading = true;
  bool _revealed = false;
  bool _finished = false;
  int _secondsLeft = _secondsPerQuestion;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final random = await DatabaseHelper().getRandomTopics(
      _questionCount * 2,
      locale: user.locale,
      excludeIds: user.readingHistoryIds.toSet(),
    );
    final ids = random.map((t) => t.id!).toList();
    final dueIds = await TopicSrsService.dueTopicIds(ids);
    final topics = dueIds.take(_questionCount).map((id) => random.firstWhere((t) => t.id == id)).toList();
    if (mounted) {
      setState(() {
        _topics = topics;
        _loading = false;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_revealed || _finished) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        setState(() => _revealed = true);
        t.cancel();
      }
    });
  }

  Future<void> _answer(bool knew) async {
    await TopicSrsService.reviewTopic(_topics[_index].id!, knew: knew);
    if (knew) _known++;
    if (_index >= _topics.length - 1) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _revealed = false;
    });
    _startTimer();
  }

  Future<void> _finish() async {
    _timer?.cancel();
    final percent = ((_known / _topics.length) * 100).round();
    await Provider.of<UserProvider>(context, listen: false).recordEncyclopediaExamScore(percent);
    setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.encyclopediaExam)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_topics.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.encyclopediaExam)),
        body: Center(child: Text(l10n.noExamTopics)),
      );
    }

    if (_finished) {
      final percent = ((_known / _topics.length) * 100).round();
      return Scaffold(
        appBar: AppBar(title: Text(l10n.examResults)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(l10n.examKnownCount(_known, _topics.length), style: theme.textTheme.headlineSmall),
                Text('$percent%', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
              ],
            ),
          ),
        ),
      );
    }

    final topic = _topics[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.encyclopediaExam),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _revealed ? '${_index + 1}/${_topics.length}' : '$_secondsLeft s',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _secondsLeft <= 5 && !_revealed ? Colors.red : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: (_index + 1) / _topics.length),
            const SizedBox(height: 24),
            Text(l10n.examTopicPrompt, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            Text(topic.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (!_revealed)
              FilledButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() => _revealed = true);
                },
                child: Text(l10n.revealAnswer),
              )
            else ...[
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(topic.description, style: const TextStyle(height: 1.5)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push(AppRoutes.topic(topic.id!)),
                child: Text(l10n.readFullTopic),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _answer(false),
                      child: Text(l10n.needStudy),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _answer(true),
                      child: Text(l10n.knewIt),
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
