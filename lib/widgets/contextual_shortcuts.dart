import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/topic.dart';
import '../router/app_router.dart';
import '../l10n/app_localizations.dart';
import '../views/zakat_calculator_screen.dart';
import '../views/inheritance_calculator_screen.dart';
import '../views/quiz_screen.dart';
import '../data/learning_content.dart';
import '../views/flashcard_screen.dart';

class ContextualShortcuts extends StatelessWidget {
  final Topic topic;

  const ContextualShortcuts({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final haystack = '${topic.title} ${topic.description} ${topic.tags.join(' ')}'.toLowerCase();
    final chips = <Widget>[];

    if (_match(haystack, ['zakat', 'nisab', 'aumône', 'زكاة'])) {
      chips.add(_chip(context, l10n.shortcutZakat, Icons.calculate, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakatCalculatorScreen()));
      }));
    }
    if (_match(haystack, ['héritage', 'inheritance', 'mira', 'faraid', 'farāʾiḍ', 'succession', 'ميراث', 'فرائض'])) {
      chips.add(_chip(context, l10n.inheritanceCalculator, Icons.account_balance_wallet, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InheritanceCalculatorScreen()));
      }));
    }
    if (_match(haystack, ['compare', 'école', 'madhhab', 'hanafi', 'maliki', 'مذهب'])) {
      chips.add(_chip(context, l10n.compareSchools, Icons.compare_arrows, () {
        context.push(AppRoutes.compare);
      }));
    }
    if (_match(haystack, ['prière', 'prayer', 'salat', 'wudu', 'ablution', 'صلاة', 'وضوء'])) {
      final deck = LearningContent.allDecks.firstWhere((d) => d.id == 'prayer', orElse: () => LearningContent.allDecks.first);
      chips.add(_chip(context, l10n.flashcards, Icons.style, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardScreen(deck: deck)));
      }));
    }
    chips.add(_chip(context, l10n.quiz, Icons.quiz, () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
    }));

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.contextualShortcuts, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: chips),
        ],
      ),
    );
  }

  bool _match(String haystack, List<String> keys) => keys.any(haystack.contains);

  Widget _chip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
