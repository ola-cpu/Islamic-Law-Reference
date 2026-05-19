import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HajjTimeline extends StatelessWidget {
  const HajjTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, String>> steps = [
      {'title': '1. Ihram', 'desc': l10n.hajjStep1Desc},
      {'title': '2. Mina', 'desc': l10n.hajjStep2Desc},
      {'title': '3. Arafat', 'desc': l10n.hajjStep3Desc},
      {'title': '4. Muzdalifah', 'desc': l10n.hajjStep4Desc},
      {'title': '5. Jamarat', 'desc': l10n.hajjStep5Desc},
      {'title': '6. Tawaf & Sa\'y', 'desc': l10n.hajjStep6Desc},
      {'title': '7. Sacrifice', 'desc': l10n.hajjStep7Desc},
    ];

    return Card(
      elevation: 0,
      color: Colors.amber.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.hajjSteps,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown),
            ),
            const SizedBox(height: 16),
            ...steps.map((step) => _buildTimelineStep(step['title']!, step['desc']!, steps.last == step)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String desc, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.amber.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
