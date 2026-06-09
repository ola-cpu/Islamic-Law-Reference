/// Registre des lots JSON de contenu encyclopédique (axe 1).
class ContentBatchRegistry {
  static const manifestPath = 'assets/content/manifest.json';

  /// Lots chargés dans l'ordre (metaKey unique par lot).
  static const batches = <({String asset, String metaKey})>[
    (asset: 'assets/content/topics_batch_1.json', metaKey: 'batch_1'),
    (asset: 'assets/content/topics_batch_2.json', metaKey: 'batch_2'),
    (asset: 'assets/content/topics_batch_3.json', metaKey: 'batch_3'),
    (asset: 'assets/content/topics_batch_4.json', metaKey: 'batch_4'),
    (asset: 'assets/content/topics_batch_5.json', metaKey: 'batch_5'),
    (asset: 'assets/content/topics_batch_6.json', metaKey: 'batch_6'),
    (asset: 'assets/content/topics_batch_7.json', metaKey: 'batch_7'),
    (asset: 'assets/content/topics_batch_8.json', metaKey: 'batch_8'),
    (asset: 'assets/content/topics_batch_9.json', metaKey: 'batch_9'),
    (asset: 'assets/content/topics_batch_10.json', metaKey: 'batch_10'),
    (asset: 'assets/content/topics_batch_11.json', metaKey: 'batch_11'),
    (asset: 'assets/content/topics_enriched_premium.json', metaKey: 'premium_enriched'),
    (asset: 'assets/content/topics_enriched_premium_2.json', metaKey: 'premium_enriched_2'),
    (asset: 'assets/content/topics_enriched_premium_3.json', metaKey: 'premium_enriched_3'),
  ];
}
