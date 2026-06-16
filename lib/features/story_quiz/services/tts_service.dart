import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ttsServiceProvider = Provider<TTSService>((ref) {
  final s = TTSService();
  ref.onDispose(() => s.dispose());
  return s;
});

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TTSService() {
    _init();
  }

  Future<void> _init() async {
    await _tts.setSharedInstance(true);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    // Slightly higher pitch for a cartoon-y voice
    await _tts.setPitch(1.2);
  }

  Future<void> speak(
    String text, {
    Function()? onStart,
    Function()? onComplete,
    Function(String)? onError,
  }) async {
    try {
      _tts.setStartHandler(() {
        if (onStart != null) onStart();
      });

      _tts.setCompletionHandler(() {
        if (onComplete != null) onComplete();
      });

      _tts.setErrorHandler((msg) {
        if (onError != null) onError(msg ?? 'TTS error');
      });

      await _tts.speak(text);
    } catch (e) {
      if (onError != null) onError(e.toString());
    }
  }

  void stop() => _tts.stop();

  void dispose() => _tts.stop();
}
