// Génère les lots JSON encyclopédiques depuis le catalogue fiqh.
// Usage: dart run tool/export_topic_batches.dart
import 'dart:convert';
import 'dart:io';

import '../lib/data/expansion/fiqh_taxonomy.dart';

void main() {
  final topics = buildFiqhTaxonomy();
  const batchSize = 50;
  const startBatch = 2; // batch_1 existe déjà
  final outDir = Directory('assets/content');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  final manifestBatches = <Map<String, dynamic>>[
    {'asset': 'assets/content/topics_batch_1.json', 'metaKey': 'batch_1'},
  ];

  var batchIndex = startBatch;
  for (var i = 0; i < topics.length; i += batchSize) {
    final slice = topics.sublist(i, (i + batchSize).clamp(0, topics.length));
    final fileName = 'topics_batch_$batchIndex.json';
    final path = '${outDir.path}/$fileName';
    final json = jsonEncode({'version': 1, 'topics': slice});
    File(path).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(jsonDecode(json)));
    manifestBatches.add({'asset': 'assets/content/$fileName', 'metaKey': 'batch_$batchIndex'});
    stdout.writeln('Wrote $path (${slice.length} topics)');
    batchIndex++;
  }

  File('${outDir.path}/manifest.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({'version': 1, 'batches': manifestBatches}),
  );
  stdout.writeln('Total topics exported: ${topics.length} in ${batchIndex - startBatch} new batches');
}
