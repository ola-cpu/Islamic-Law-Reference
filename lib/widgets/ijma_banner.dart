import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class IjmaBanner extends StatelessWidget {
  const IjmaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.handshake, color: Colors.green.shade800),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.ijmaSection, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(l10n.ijmaSectionDesc, style: const TextStyle(fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
