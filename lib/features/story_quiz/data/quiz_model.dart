class QuizModel {
  final String question;
  final List<String> options;
  final String answer;

  const QuizModel({
    required this.question,
    required this.options,
    required this.answer,
  });

  // Factory constructor to safely parse dynamic JSON structures
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? 
          [],
      answer: json['answer'] as String? ?? '',
    );
  }

  // Handy mockup generator to simulate an incoming backend JSON payload
  static QuizModel get mockUp {
    final Map<String, dynamic> mockJson = {
      "question": "What colour was Pip the Robot's lost gear?",
      "options": ["Red", "Green", "Blue", "Yellow"],
      "answer": "Blue"
    };
    return QuizModel.fromJson(mockJson);
  }
}