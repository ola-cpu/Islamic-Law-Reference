import 'package:flutter/material.dart';
import '../models/badge.dart';

class InteractiveWuduDiagram extends StatefulWidget {
  const InteractiveWuduDiagram({super.key});

  @override
  State<InteractiveWuduDiagram> createState() => _InteractiveWuduDiagramState();
}

class _InteractiveWuduDiagramState extends State<InteractiveWuduDiagram> {
  final Set<String> _selected = {};

  static const _zones = [
    _WuduZone('face', Icons.face, 'Visage', 'Face', 'الوجه'),
    _WuduZone('arms', Icons.back_hand, 'Bras', 'Arms', 'اليدان'),
    _WuduZone('head', Icons.self_improvement, 'Tête', 'Head', 'الرأس'),
    _WuduZone('feet', Icons.directions_walk, 'Pieds', 'Feet', 'الرجلين'),
  ];

  String _label(_WuduZone zone, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return zone.en;
      case 'ar':
        return zone.ar;
      default:
        return zone.fr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.languageCode == 'en'
                  ? 'Interactive Wudu zones — tap each zone'
                  : locale.languageCode == 'ar'
                      ? 'مناطق الوضوء التفاعلية — اضغط على كل منطقة'
                      : 'Zones du wudu interactives — touchez chaque zone',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _zones.map((zone) {
                final selected = _selected.contains(zone.id);
                return FilterChip(
                  selected: selected,
                  avatar: Icon(zone.icon, size: 18, color: selected ? Colors.white : theme.colorScheme.primary),
                  label: Text(_label(zone, locale)),
                  selectedColor: theme.colorScheme.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(color: selected ? Colors.white : null),
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        _selected.remove(zone.id);
                      } else {
                        _selected.add(zone.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_selected.length == _zones.length) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locale.languageCode == 'en'
                          ? 'All four zones covered — valid wudu structure!'
                          : locale.languageCode == 'ar'
                              ? 'جميع المناطق الأربع — هيكل وضوء صحيح!'
                              : 'Les 4 zones couvertes — structure de wudu valide !',
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WuduZone {
  final String id;
  final IconData icon;
  final String fr;
  final String en;
  final String ar;
  const _WuduZone(this.id, this.icon, this.fr, this.en, this.ar);
}

class InteractiveInheritanceDiagram extends StatefulWidget {
  const InteractiveInheritanceDiagram({super.key});

  @override
  State<InteractiveInheritanceDiagram> createState() => _InteractiveInheritanceDiagramState();
}

class _InteractiveInheritanceDiagramState extends State<InteractiveInheritanceDiagram> {
  String? _selectedHeir;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final isEn = locale.languageCode == 'en';
    final isAr = locale.languageCode == 'ar';

    final heirs = [
      _HeirInfo('spouse_m', Icons.man, isEn ? 'Husband' : isAr ? 'الزوج' : 'Mari', isEn ? '1/2 or 1/4' : isAr ? '1/2 أو 1/4' : '1/2 ou 1/4'),
      _HeirInfo('spouse_f', Icons.woman, isEn ? 'Wife' : isAr ? 'الزوجة' : 'Femme', isEn ? '1/4 or 1/8' : isAr ? '1/4 أو 1/8' : '1/4 ou 1/8'),
      _HeirInfo('son', Icons.boy, isEn ? 'Son' : isAr ? 'الابن' : 'Fils', isEn ? 'Residuary (asaba)' : isAr ? 'عصبة' : 'Residuaire (asaba)'),
      _HeirInfo('daughter', Icons.girl, isEn ? 'Daughter' : isAr ? 'البنت' : 'Fille', isEn ? '1/2 or 2/3 shared' : isAr ? '1/2 أو 2/3' : '1/2 ou 2/3 partagé'),
    ];

    return Card(
      elevation: 0,
      color: Colors.brown.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.brown.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEn ? 'Inheritance tree — tap an heir' : isAr ? 'شجرة الميراث — اضغط على وارث' : 'Arbre d\'héritage — touchez un héritier',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.brown.shade800),
            ),
            const SizedBox(height: 12),
            ...heirs.map((heir) {
              final selected = _selectedHeir == heir.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: selected ? Colors.brown.withValues(alpha: 0.15) : Colors.brown.withValues(alpha: 0.05),
                  leading: CircleAvatar(
                    backgroundColor: selected ? Colors.brown : Colors.brown.shade100,
                    child: Icon(heir.icon, color: selected ? Colors.white : Colors.brown.shade700),
                  ),
                  title: Text(heir.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: selected ? Text(heir.share, style: TextStyle(color: Colors.brown.shade700)) : null,
                  trailing: Icon(selected ? Icons.expand_less : Icons.chevron_right, color: Colors.brown),
                  onTap: () => setState(() => _selectedHeir = selected ? null : heir.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HeirInfo {
  final String id;
  final IconData icon;
  final String name;
  final String share;
  const _HeirInfo(this.id, this.icon, this.name, this.share);
}

bool topicShowsWuduDiagram(String title) {
  final t = title.toLowerCase();
  return t.contains('wudu') || t.contains('wuḍū') || t.contains('ablution') || t.contains('وضو');
}

bool topicShowsInheritanceDiagram(String title) {
  final t = title.toLowerCase();
  return t.contains('héritage') || t.contains('inheritance') || t.contains('mira') || t.contains('succession') || t.contains('conjoint') || t.contains('spouse');
}
