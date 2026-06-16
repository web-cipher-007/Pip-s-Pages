import '../data/quiz_model.dart';

enum StoryAudioStatus {
  idle,
  loadingAudio,
  playingAudio,
  audioError,
  quizActive,
  quizSuccess,
}

class StoryState {
  final StoryAudioStatus status;
  final QuizModel? quiz;
  final String? selectedAnswer;
  final bool isAnswerWrong;
  final String? errorMessage;

  const StoryState({
    this.status = StoryAudioStatus.idle, // Add this default value!
    this.quiz,
    this.selectedAnswer,
    this.isAnswerWrong = false,
    this.errorMessage,
  });

  // Zero-state initialization helper
  factory StoryState.initial() {
    return const StoryState(status: StoryAudioStatus.idle);
  }

  // Immutability helper to safely emit modifications down to Riverpod providers
  StoryState copyWith({
    StoryAudioStatus? status,
    QuizModel? quiz,
    String? selectedAnswer,
    bool? isAnswerWrong,
    String? errorMessage,
  }) {
    return StoryState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAnswerWrong: isAnswerWrong ?? this.isAnswerWrong,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}