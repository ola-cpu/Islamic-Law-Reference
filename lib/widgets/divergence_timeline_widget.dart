import 'package:flutter/material.dart';
import '../models/law.dart';
import '../l10n/app_localizations.dart';
import '../services/database_helper.dart';

/// Timeline des divergences inter-madhhab pour un sujet.
class DivergenceTimelineWidget extends StatelessWidget {
  final List<Law> laws;

  const DivergenceTimelineWidget({super.key, required this.laws});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (laws.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.divergenceTimeline, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...laws.asMap().entries.map((entry) {
          final index = entry.key;
          final law = entry.value;
          final isLast = index == laws.length - 1;
          return FutureBuilder(
            future: DatabaseHelper().getSchoolById(law.schoolId),
            builder: (context, snap) {
              final school = snap.data?.name ?? law.title;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 28,
                      child: Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: _color(index), shape: BoxShape.circle),
                          ),
                          if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(school, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(law.content, style: const TextStyle(fontSize: 13, height: 1.4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Color _color(int i) {
    const colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    return colors[i % colors.length];
  }
}
