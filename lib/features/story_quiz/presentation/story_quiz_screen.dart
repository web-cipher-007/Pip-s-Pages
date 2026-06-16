import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import '../data/quiz_model.dart';
import '../domain/story_state.dart';
import '../domain/story_notifier.dart';

/// Upgraded Kid-Friendly Color Vibe Palette
class BrandPalette {
  static const Color primaryPurple = Color(0xFF6F2BC2);
  static const Color darkIndigo = Color(0xFF36165E);
  static const Color softGreyBg = Color(0xFFF6F3FA);
  static const Color playfulYellow = Color(0xFFFFD23F);
  static const Color bubbleCyan = Color(0xFFE0F7FA);
}

class StoryQuizScreen extends ConsumerStatefulWidget {
  const StoryQuizScreen({super.key});

  @override
  ConsumerState<StoryQuizScreen> createState() => _StoryQuizScreenState();
}

class _StoryQuizScreenState extends ConsumerState<StoryQuizScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  
  // Exact written narrative text snippet from the primary requirements document
  final String _narrativeText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyProvider);

    ref.listen<StoryState>(storyProvider, (previous, next) {
      if (next.isAnswerWrong) {
        _shakeController.forward(from: 0.0);
      }
      if (next.status == StoryAudioStatus.quizSuccess && previous?.status != StoryAudioStatus.quizSuccess) {
        Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 100,
            spread: 80,
            y: 0.5,
            colors: [Colors.purple, Colors.yellow, Colors.cyan, Colors.pink, Colors.green],
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: BrandPalette.softGreyBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: const Icon(Icons.arrow_back_rounded, color: BrandPalette.primaryPurple),
          ),
        ),
        title: Text(
          'Pip\'s Pages',
          style: GoogleFonts.fredoka(
            color: BrandPalette.darkIndigo,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: BrandPalette.playfulYellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, color: BrandPalette.darkIndigo, size: 20),
                  Gap(4),
                  Text('10', style: TextStyle(fontWeight: FontWeight.bold, color: BrandPalette.darkIndigo)),
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Interactive Isolated AI Buddy Container
              AiBuddyWidget(status: state.status),
              const Gap(20),

              // 2. Kid Storybook Layout Card Block
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: BrandPalette.darkIndigo.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: BrandPalette.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '📖 THE ADVENTURE BEGINS',
                        style: GoogleFonts.fredoka(
                          color: BrandPalette.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      _narrativeText,
                      style: GoogleFonts.quicksand(
                        color: BrandPalette.darkIndigo,
                        fontSize: 20,
                        height: 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),

              // 3. Playful Audio Execution Controls
              if (state.status == StoryAudioStatus.idle ||
                  state.status == StoryAudioStatus.loadingAudio ||
                  state.status == StoryAudioStatus.playingAudio ||
                  state.status == StoryAudioStatus.audioError)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: BrandPalette.primaryPurple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: state.status == StoryAudioStatus.loadingAudio
                        ? null
                        : () => ref.read(storyProvider.notifier).readStory(_narrativeText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandPalette.primaryPurple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: BrandPalette.primaryPurple.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    icon: state.status == StoryAudioStatus.loadingAudio
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : Icon(
                            state.status == StoryAudioStatus.playingAudio
                                ? Icons.volume_up_rounded
                                : Icons.play_arrow_rounded,
                            size: 28,
                          ),
                    label: Text(
                      state.status == StoryAudioStatus.loadingAudio
                          ? 'Warming up the magic voice...'
                          : state.status == StoryAudioStatus.playingAudio
                              ? 'Listen closely...'
                              : 'Read Me the Story! ✨',
                      style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              if (state.status == StoryAudioStatus.audioError) ...[
                const Gap(12),
                Text(
                  state.errorMessage ?? 'An audio error occurred.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(color: Colors.red[700], fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],

              // 4. Data-Driven Animated Quiz Section
              if (state.status == StoryAudioStatus.quizActive || state.status == StoryAudioStatus.quizSuccess) ...[
                const Gap(12),
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    double offset = 0.0;
                    if (_shakeController.value > 0) {
                      offset = sin(_shakeController.value * pi * 4) * 12.0;
                    }
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: QuizEngineWidget(
                    quiz: state.quiz!,
                    selectedAnswer: state.selectedAnswer,
                    isSuccess: state.status == StoryAudioStatus.quizSuccess,
                    onSelect: (option) => ref.read(storyProvider.notifier).checkAnswer(option),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Upgraded Custom AI Buddy Widget (Locked 60fps vertical bouncing framework)
class AiBuddyWidget extends StatefulWidget {
  final StoryAudioStatus status;
  const AiBuddyWidget({super.key, required this.status});

  @override
  State<AiBuddyWidget> createState() => _AiBuddyWidgetState();
}

class _AiBuddyWidgetState extends State<AiBuddyWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _bobbingController;
  late final Animation<double> _yAnimation;

  @override
  void initState() {
    super.initState();
    _bobbingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _yAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _bobbingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bobbingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _yAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _yAnimation.value),
          child: child,
        );
      },
      child: Center(
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, BrandPalette.bubbleCyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: BrandPalette.primaryPurple.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.status == StoryAudioStatus.quizSuccess
                      ? Icons.sentiment_very_satisfied_rounded
                      : widget.status == StoryAudioStatus.playingAudio
                          ? Icons.spatial_audio_off_rounded
                          : Icons.smart_toy_rounded,
                  key: ValueKey<StoryAudioStatus>(widget.status),
                  size: 72,
                  color: BrandPalette.primaryPurple,
                ),
              ),
              const Gap(4),
              Text(
                widget.status == StoryAudioStatus.quizSuccess
                    ? "Yay! Corect!"
                    : widget.status == StoryAudioStatus.playingAudio
                        ? "Pip is reading..."
                        : "Tap Below!",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  color: BrandPalette.darkIndigo,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Upgraded Puzzle-Like Data Driven Quiz Renderer
class QuizEngineWidget extends StatelessWidget {
  final QuizModel quiz;
  final String? selectedAnswer;
  final bool isSuccess;
  final ValueChanged<String> onSelect;

  const QuizEngineWidget({
    super.key,
    required this.quiz,
    required this.selectedAnswer,
    required this.isSuccess,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quiz.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              color: BrandPalette.darkIndigo,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          ...quiz.options.map((option) {
            final isThisSelected = selectedAnswer == option;
            Color buttonColor = Colors.white;
            Color borderColor = BrandPalette.softGreyBg;
            Color textColor = BrandPalette.darkIndigo;
            
            if (isThisSelected) {
              if (isSuccess && option == quiz.answer) {
                buttonColor = const Color(0xFF4CAF50);
                borderColor = const Color(0xFF388E3C);
                textColor = Colors.white;
              } else {
                buttonColor = const Color(0xFFE57373);
                borderColor = const Color(0xFFD32F2F);
                textColor = Colors.white;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (!isSuccess)
                      BoxShadow(
                        color: isThisSelected ? borderColor.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.03),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      )
                  ],
                ),
                child: OutlinedButton(
                  onPressed: isSuccess ? null : () => onSelect(option),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: buttonColor,
                    side: BorderSide(
                      color: isThisSelected ? borderColor : const Color(0xFFE0DBEC),
                      width: 2.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: GoogleFonts.fredoka(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isThisSelected && isSuccess && option == quiz.answer)
                        const Icon(Icons.check_circle_rounded, color: Colors.white)
                      else if (isThisSelected && !isSuccess)
                        const Icon(Icons.cancel_rounded, color: Colors.white)
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE0DBEC), width: 2),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
          if (isSuccess) ...[
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "🎉 Woohoo! You found Pip's blue gear!",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  color: const Color(0xFF2E7D32),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}