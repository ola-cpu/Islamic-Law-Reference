import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService instance = TtsService._();
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  String? _currentKey;

  bool get isSpeaking => _currentKey != null;
  String? get currentKey => _currentKey;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    _tts.setCompletionHandler(() => _currentKey = null);
    _tts.setCancelHandler(() => _currentKey = null);
    _initialized = true;
  }

  String _localeCode(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'ar-SA';
      case 'fr':
        return 'fr-FR';
      case 'ru':
        return 'ru-RU';
      case 'zh':
        return 'zh-CN';
      default:
        return 'en-US';
    }
  }

  Future<void> speak(String key, String text, Locale locale) async {
    await init();
    if (text.trim().isEmpty) return;

    if (_currentKey == key) {
      await stop();
      return;
    }

    await _tts.stop();
    await _tts.setLanguage(_localeCode(locale));
    _currentKey = key;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _currentKey = null;
  }
}
