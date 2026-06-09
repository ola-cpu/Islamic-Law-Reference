import 'package:flutter/material.dart';
import '../services/skill_tree_service.dart';
import '../l10n/app_localizations.dart';

class SkillTreeWidget extends StatelessWidget {
  final List<SkillNode> nodes;

  const SkillTreeWidget({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (nodes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.skillTree, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...nodes.take(6).map((node) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(node.category.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                      Text(
                        l10n.skillProgress(node.readTopics, node.totalTopics),
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: node.progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
