import 'package:flutter/material.dart';

class BuiltinIllustration extends StatelessWidget {
  final String widgetId;
  final double height;

  const BuiltinIllustration({
    super.key,
    required this.widgetId,
    this.height = 160,
  });

  static bool isBuiltin(String url) => url.startsWith('widget:');

  static String idFromUrl(String url) => url.replaceFirst('widget:', '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (widgetId) {
      case 'wudu_zones':
        return _buildLabeledGrid(context, [
          _ZoneItem(Icons.face, 'Visage'),
          _ZoneItem(Icons.back_hand, 'Bras'),
          _ZoneItem(Icons.self_improvement, 'Tête'),
          _ZoneItem(Icons.directions_walk, 'Pieds'),
        ]);
      case 'ghusl_body':
        return _buildCenterIcon(
          context,
          Icons.person,
          'Corps entier',
          'Eau sur tout le corps, y compris les cheveux',
        );
      case 'zakat_nisab':
        return _buildLabeledGrid(context, [
          _ZoneItem(Icons.diamond, '85g or'),
          _ZoneItem(Icons.circle, '595g argent'),
          _ZoneItem(Icons.percent, '2,5%'),
        ]);
      case 'qasr_prayer':
        return _buildCenterIcon(
          context,
          Icons.flight,
          '4 → 2 rak\'ats',
          'Raccourcissement en voyage',
        );
      case 'inheritance_spouse':
        return _buildLabeledGrid(context, [
          _ZoneItem(Icons.man, 'Mari : 1/2 ou 1/4'),
          _ZoneItem(Icons.woman, 'Femme : 1/4 ou 1/8'),
        ]);
      default:
        return Center(
          child: Icon(Icons.image, size: 48, color: Theme.of(context).colorScheme.primary),
        );
    }
  }

  Widget _buildCenterIcon(BuildContext context, IconData icon, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildLabeledGrid(BuildContext context, List<_ZoneItem> items) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: items.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                child: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(item.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ZoneItem {
  final IconData icon;
  final String label;
  const _ZoneItem(this.icon, this.label);
}
