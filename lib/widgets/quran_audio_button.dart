import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuranAudioButton extends StatefulWidget {
  final String text;
  final String? tooltip;

  const QuranAudioButton({
    super.key,
    required this.text,
    this.tooltip,
  });

  @override
  State<QuranAudioButton> createState() => _QuranAudioButtonState();
}

class _QuranAudioButtonState extends State<QuranAudioButton> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    if (mounted) setState(() => _ready = true);
  }

  Future<void> _toggle() async {
    if (!_ready || widget.text.trim().isEmpty) return;
    if (_speaking) {
      await _tts.stop();
      setState(() => _speaking = false);
      return;
    }
    setState(() => _speaking = true);
    await _tts.speak(widget.text);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_speaking ? Icons.stop_circle : Icons.volume_up),
      color: _speaking ? Colors.green : Colors.blueGrey,
      tooltip: widget.tooltip,
      onPressed: _ready ? _toggle : null,
    );
  }
}
