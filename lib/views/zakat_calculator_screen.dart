import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _goldController = TextEditingController();
  final _silverController = TextEditingController();
  final _cashController = TextEditingController();
  final _goldPriceController = TextEditingController(text: '65');

  double? _zakatDue;
  bool? _reachesNisab;
  String? _detail;

  static const _goldNisab = 85.0;
  static const _silverNisab = 595.0;
  static const _zakatRate = 0.025;

  @override
  void dispose() {
    _goldController.dispose();
    _silverController.dispose();
    _cashController.dispose();
    _goldPriceController.dispose();
    super.dispose();
  }

  void _calculate(AppLocalizations l10n) {
    final gold = double.tryParse(_goldController.text.replaceAll(',', '.')) ?? 0;
    final silver = double.tryParse(_silverController.text.replaceAll(',', '.')) ?? 0;
    final cash = double.tryParse(_cashController.text.replaceAll(',', '.')) ?? 0;
    final goldPrice = double.tryParse(_goldPriceController.text.replaceAll(',', '.')) ?? 65;

    final goldValue = gold * goldPrice;
    final silverValue = silver * (_silverNisab > 0 ? (goldPrice * _goldNisab / 595) : 0.75);
    final totalWealth = goldValue + silverValue + cash;

    final nisabValue = _goldNisab * goldPrice;
    final due = totalWealth >= nisabValue ? totalWealth * _zakatRate : 0.0;

    setState(() {
      _reachesNisab = totalWealth >= nisabValue;
      _zakatDue = due;
      _detail = l10n.zakatCalcDetail(
        gold.toStringAsFixed(1),
        silver.toStringAsFixed(0),
        cash.toStringAsFixed(0),
        nisabValue.toStringAsFixed(0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.zakatCalculator)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.zakatCalculatorDesc, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 20),
          _field(l10n.goldGrams, _goldController, l10n.goldGramsHint),
          _field(l10n.silverGrams, _silverController, l10n.silverGramsHint),
          _field(l10n.cashAmount, _cashController, l10n.cashAmountHint),
          _field(l10n.goldPricePerGram, _goldPriceController, l10n.goldPriceHint),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _calculate(l10n),
            icon: const Icon(Icons.calculate),
            label: Text(l10n.calculateZakat),
          ),
          if (_zakatDue != null) ...[
            const SizedBox(height: 24),
            Card(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      _reachesNisab! ? Icons.volunteer_activism : Icons.info_outline,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _reachesNisab! ? l10n.zakatDue(_zakatDue!.toStringAsFixed(2)) : l10n.belowNisab,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (_detail != null) ...[
                      const SizedBox(height: 8),
                      Text(_detail!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      l10n.zakatRateNote,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(l10n.learnMoreZakat),
              subtitle: Text(l10n.zakatTopicHint),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final topic = await userProvider.resolveTopicByTitle('Le Nisab de la Zakat');
                if (topic != null && context.mounted) {
                  context.push(AppRoutes.topic(topic.id!));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
