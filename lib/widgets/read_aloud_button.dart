import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/tts_service.dart';

class ReadAloudButton extends StatefulWidget {
  final String speakKey;
  final String text;
  final String? tooltip;

  const ReadAloudButton({
    super.key,
    required this.speakKey,
    required this.text,
    this.tooltip,
  });

  @override
  State<ReadAloudButton> createState() => _ReadAloudButtonState();
}

class _ReadAloudButtonState extends State<ReadAloudButton> {
  @override
  void initState() {
    super.initState();
    TtsService.instance.init();
  }

  bool get _isActive => TtsService.instance.currentKey == widget.speakKey;

  Future<void> _toggle() async {
    final locale = Provider.of<UserProvider>(context, listen: false).locale;
    await TtsService.instance.speak(widget.speakKey, widget.text, locale);
    if (mounted) setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isActive ? Icons.stop_circle : Icons.record_voice_over),
      color: _isActive ? Colors.green : null,
      tooltip: widget.tooltip,
      onPressed: widget.text.trim().isEmpty ? null : _toggle,
    );
  }
}
