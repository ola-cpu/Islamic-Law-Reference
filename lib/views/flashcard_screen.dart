import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/learning_content.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../services/srs_service.dart';

class FlashcardScreen extends StatefulWidget {
  final FlashcardDeck deck;

  const FlashcardScreen({super.key, required this.deck});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  List<int> _order = [];
  int _pos = 0;
  bool _showAnswer = false;
  bool _loading = true;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  int get _index => _order.isEmpty ? 0 : _order[_pos];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final due = await SrsService.dueIndices(widget.deck.id, widget.deck.cards.length);
    if (mounted) {
      setState(() {
        _order = due;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showAnswer) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _showAnswer = !_showAnswer);
  }

  Future<void> _review(bool good) async {
    final key = SrsService.cardKey(widget.deck.id, _index);
    await SrsService.review(key, good: good);
    if (_pos >= _order.length - 1) {
      await _finish();
      return;
    }
    _flipController.reset();
    setState(() {
      _pos++;
      _showAnswer = false;
    });
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context)!;
    await Provider.of<UserProvider>(context, listen: false).recordFlashcardDeckCompleted();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deckComplete),
        content: Text(l10n.deckCompleteMessage(_order.length)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    if (_loading || _order.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.deck.title(locale))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final card = widget.deck.cards[_index];
    final progress = (_pos + 1) / _order.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title(locale)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_pos + 1}/${_order.length}')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: progress, minHeight: 6, borderRadius: BorderRadius.circular(3)),
            const SizedBox(height: 8),
            Text(l10n.srsMode, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * 3.14159;
                    final isBack = angle > 1.5708;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: isBack
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: _CardFace(
                                label: l10n.answer,
                                text: card.answer(locale),
                                color: theme.colorScheme.secondaryContainer,
                              ),
                            )
                          : _CardFace(
                              label: l10n.question,
                              text: card.question(locale),
                              color: theme.colorScheme.primaryContainer,
                            ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.tapToFlip, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 16),
            if (_showAnswer)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _review(false),
                      icon: const Icon(Icons.replay),
                      label: Text(l10n.reviewAgain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _review(true),
                      icon: const Icon(Icons.check),
                      label: Text(l10n.knewIt),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  const _CardFace({required this.label, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
