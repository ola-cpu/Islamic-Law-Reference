import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../widgets/read_aloud_button.dart';

class ZenReaderScreen extends StatefulWidget {
  final Topic topic;
  final List<Law> laws;

  const ZenReaderScreen({
    super.key,
    required this.topic,
    required this.laws,
  });

  @override
  State<ZenReaderScreen> createState() => _ZenReaderScreenState();
}

class _ZenReaderScreenState extends State<ZenReaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).recordZenModeUsed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context);
    final isAr = user.locale.languageCode == 'ar';
    final scale = user.zenFontScale;

    final readText = StringBuffer()
      ..writeln(widget.topic.title)
      ..writeln()
      ..writeln(widget.topic.description);
    for (final law in widget.laws) {
      readText
        ..writeln()
        ..writeln(law.title)
        ..writeln(law.content);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white70,
          elevation: 0,
          title: Text(l10n.zenMode, style: const TextStyle(fontSize: 16)),
          actions: [
            ReadAloudButton(
              speakKey: 'zen_${widget.topic.id}',
              text: readText.toString(),
              tooltip: l10n.readAloud,
            ),
            IconButton(
              icon: const Icon(Icons.text_increase),
              tooltip: l10n.increaseFont,
              onPressed: () => user.setZenFontScale((scale + 0.1).clamp(0.8, 1.6)),
            ),
            IconButton(
              icon: const Icon(Icons.text_decrease),
              tooltip: l10n.decreaseFont,
              onPressed: () => user.setZenFontScale((scale - 0.1).clamp(0.8, 1.6)),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topic.title,
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(
                    color: const Color(0xFFF5F0E8),
                    fontSize: 26 * scale,
                    fontWeight: FontWeight.bold,
                    fontFamily: isAr ? 'Amiri' : null,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.topic.description,
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(
                    color: const Color(0xFFD4CFC4),
                    fontSize: 18 * scale,
                    fontFamily: isAr ? 'Amiri' : null,
                    height: 1.7,
                  ),
                ),
                if (widget.laws.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Divider(color: Colors.white.withValues(alpha: 0.15)),
                  const SizedBox(height: 16),
                  ...widget.laws.map((law) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              law.title,
                              style: TextStyle(
                                color: const Color(0xFF81C784),
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (law.contentAr != null && isAr)
                              Text(
                                law.contentAr!,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: const Color(0xFFE8E4DC),
                                  fontSize: 17 * scale,
                                  fontFamily: 'Amiri',
                                  height: 1.8,
                                ),
                              ),
                            if (!isAr || law.contentAr == null)
                              Text(
                                law.content,
                                textAlign: isAr ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  color: const Color(0xFFE8E4DC),
                                  fontSize: 17 * scale,
                                  height: 1.8,
                                ),
                              ),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
