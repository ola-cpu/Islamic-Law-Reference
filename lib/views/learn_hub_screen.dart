import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../data/learning_content.dart';
import '../data/guided_courses.dart';
import '../l10n/app_localizations.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'zakat_calculator_screen.dart';
import 'inheritance_calculator_screen.dart';
import 'practical_cases_screen.dart';

class LearnHubScreen extends StatelessWidget {
  const LearnHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.learnHub)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.learnHubSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
          const SizedBox(height: 20),
          _SectionHeader(title: l10n.tools),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(Icons.calculate, color: Colors.orange.shade800),
              ),
              title: Text(l10n.zakatCalculator),
              subtitle: Text(l10n.zakatCalculatorShort),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ZakatCalculatorScreen()),
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade100,
                child: Icon(Icons.account_balance_wallet, color: Colors.brown.shade800),
              ),
              title: Text(l10n.inheritanceCalculator),
              subtitle: Text(l10n.inheritanceCalculatorShort),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InheritanceCalculatorScreen()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.practicalCases),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(Icons.auto_awesome, color: Colors.deepPurple.shade800),
              ),
              title: Text(l10n.situationAdvisor),
              subtitle: Text(l10n.situationAdvisorDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AppRoutes.situation),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade50,
                child: Icon(Icons.search, color: Colors.deepPurple.shade600),
              ),
              title: Text(l10n.scenarioFinder),
              subtitle: Text(l10n.scenarioFinderDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AppRoutes.scenarios),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: Icon(Icons.psychology, color: Colors.indigo.shade800),
              ),
              title: Text(l10n.practicalCases),
              subtitle: Text(l10n.practicalCasesDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PracticalCasesScreen()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.compareSchools),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Icon(Icons.compare_arrows, color: Colors.teal.shade800),
              ),
              title: Text(l10n.compareSchools),
              subtitle: Text(l10n.compareHubDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AppRoutes.compare),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.guidedCourses),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.route, color: theme.colorScheme.primary),
              ),
              title: Text(l10n.guidedCourses),
              subtitle: Text(l10n.courseCount(GuidedCourses.all.length)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AppRoutes.courses),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.flashcards),
          ...LearningContent.allDecks.map((deck) => _DeckTile(
                icon: deck.icon,
                title: deck.title(Localizations.localeOf(context)),
                subtitle: l10n.cardCount(deck.cards.length),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlashcardScreen(deck: deck)),
                  );
                },
              )),
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.quiz),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.quiz, color: theme.colorScheme.primary),
              ),
              title: Text(l10n.quizGeneral),
              subtitle: Text(l10n.quizQuestionCount(LearningContent.quizQuestions.length)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade100,
                child: Icon(Icons.timer, color: Colors.red.shade800),
              ),
              title: Text(l10n.examMode),
              subtitle: Text(l10n.examModeDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen(examMode: true)),
                );
              },
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade100,
                child: Icon(Icons.library_books, color: Colors.brown.shade800),
              ),
              title: Text(l10n.encyclopediaExam),
              subtitle: Text(l10n.encyclopediaExamDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push(AppRoutes.encyclopediaExam),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _DeckTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DeckTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
