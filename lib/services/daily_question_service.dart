import '../data/learning_content.dart';

class DailyQuestionService {
  static QuizQuestion questionForToday() {
    final questions = LearningContent.quizQuestions;
    if (questions.isEmpty) {
      throw StateError('No quiz questions');
    }
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return questions[dayOfYear % questions.length];
  }

  static int dayIndex() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return dayOfYear % LearningContent.quizQuestions.length;
  }
}
