import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/quiz_model.dart';
import 'story_state.dart';

final storyProvider = StateNotifierProvider<StoryNotifier, StoryState>((ref) {
  return StoryNotifier();
});

class StoryNotifier extends StateNotifier<StoryState> {
  final FlutterTts _tts = FlutterTts();
  bool _isEngineInitialized = false;

  StoryNotifier() : super(const StoryState()) {
    _setupTtsHandlers();
  }

  /// Configures lifecycle handlers and pre-warms the native engine connection
  void _setupTtsHandlers() {
    _tts.setStartHandler(() {
      state = state.copyWith(status: StoryAudioStatus.playingAudio);
    });

    _tts.setCompletionHandler(() {
      // Once narration finishes, feed the dynamic, data-driven mock payload
      state = state.copyWith(
        status: StoryAudioStatus.quizActive,
        quiz: QuizModel.mockUp,
      );
    });

    _tts.setErrorHandler((message) {
      state = state.copyWith(
        status: StoryAudioStatus.audioError,
        errorMessage: "Oh no! Pip's voice engine encountered an error: $message",
      );
    });
  }

  /// Deeply initializes and binds to the OS native TTS engine
  Future<bool> _ensureEngineReady() async {
    if (_isEngineInitialized) return true;

    try {
      // Forces the operating system to bind to its default TTS language engine
      // This solves the 'not bound to TTS engine' error by completing the handshakes first
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.45); // Set a pleasant, readable speed for children
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.1); // Slightly higher pitch for a friendly cartoon character voice
      
      _isEngineInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Narrates the story safely, managing preparation states to prevent binding crashes
  Future<void> readStory(String text) async {
    // 1. Instantly set state to loading to update UI spinners and disable dual-clicks
    state = state.copyWith(status: StoryAudioStatus.loadingAudio);

    // 2. Resolve the system binding pipeline
    final isReady = await _ensureEngineReady();

    if (!isReady) {
      state = state.copyWith(
        status: StoryAudioStatus.audioError,
        errorMessage: "Could not bind to your device's voice engine. Please try again!",
      );
      return;
    }

    try {
      // 3. Small defensive delay to guarantee native engine context stability on slower devices
      await Future.delayed(const Duration(milliseconds: 150));
      
      // 4. Safe execution now that binding guarantees are satisfied
      await _tts.speak(text);
    } catch (e) {
      state = state.copyWith(
        status: StoryAudioStatus.audioError,
        errorMessage: "Voice engine failed to start. Is your device sound turned on?",
      );
    }
  }

  /// Handles game engine mechanics when an option button is tapped
  void checkAnswer(String chosenOption) async {
    if (state.quiz == null || state.status == StoryAudioStatus.quizSuccess) return;

    final currentQuiz = state.quiz!;
    state = state.copyWith(selectedAnswer: chosenOption);

    if (chosenOption == currentQuiz.answer) {
      state = state.copyWith(status: StoryAudioStatus.quizSuccess);
    } else {
      // Trigger kid-friendly silent correction boundary
      state = state.copyWith(isAnswerWrong: true);
      HapticFeedback.lightImpact();

      // Leave shake active briefly, then reset option selections to allow retry
      await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(isAnswerWrong: false, selectedAnswer: null);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}