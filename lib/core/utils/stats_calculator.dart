/// حاسبة الإحصائيات المركزية
/// توفر حسابات موحدة للإحصائيات عبر التطبيق
class StatsCalculator {
  /// حساب الإحصائيات من البيانات الخام
  /// 
  /// Parameters:
  /// - totalQuestions: إجمالي عدد الأسئلة
  /// - answeredQuestions: عدد الأسئلة المجابة (لها سجل في progress)
  /// - correctAnswers: عدد الإجابات الصحيحة (status = 2)
  static QuestionStats calculate({
    required int totalQuestions,
    required int answeredQuestions,
    required int correctAnswers,
  }) {
    // حساب الأسئلة الجديدة (لم يتم الإجابة عليها)
    final newQuestions = totalQuestions - answeredQuestions;
    
    // حساب الأسئلة الخاطئة (مجابة لكن خاطئة)
    final incorrectAnswers = answeredQuestions - correctAnswers;
    
    // حساب نسبة الإتمام (الأسئلة المجابة / إجمالي الأسئلة)
    final completionRate = totalQuestions > 0
        ? (answeredQuestions / totalQuestions) * 100
        : 0.0;
    
    // حساب نسبة الدقة (الإجابات الصحيحة / الأسئلة المجابة)
    final accuracyRate = answeredQuestions > 0
        ? (correctAnswers / answeredQuestions) * 100
        : 0.0;

    return QuestionStats(
      totalQuestions: totalQuestions,
      newQuestions: newQuestions,
      answeredQuestions: answeredQuestions,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
      completionRate: completionRate,
      accuracyRate: accuracyRate,
    );
  }

  /// حساب عدد الأسئلة المتبقية (جديدة + خاطئة)
  static int calculateRemainingQuestions({
    required int newQuestions,
    required int incorrectAnswers,
  }) {
    return newQuestions + incorrectAnswers;
  }
}

/// كلاس يحتوي على كل الإحصائيات المحسوبة
class QuestionStats {
  /// إجمالي عدد الأسئلة
  final int totalQuestions;
  
  /// عدد الأسئلة الجديدة (لم يتم الإجابة عليها)
  final int newQuestions;
  
  /// عدد الأسئلة المجابة (لها سجل progress)
  final int answeredQuestions;
  
  /// عدد الإجابات الصحيحة
  final int correctAnswers;
  
  /// عدد الإجابات الخاطئة
  final int incorrectAnswers;
  
  /// نسبة الإتمام (%)
  final double completionRate;
  
  /// نسبة الدقة (%)
  final double accuracyRate;

  const QuestionStats({
    required this.totalQuestions,
    required this.newQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.completionRate,
    required this.accuracyRate,
  });

  /// عدد الأسئلة المتبقية (جديدة + خاطئة)
  int get remainingQuestions => newQuestions + incorrectAnswers;

  /// هل يوجد أسئلة جديدة؟
  bool get hasNewQuestions => newQuestions > 0;

  /// هل يوجد أسئلة خاطئة؟
  bool get hasIncorrectAnswers => incorrectAnswers > 0;

  /// هل وصل المستخدم للإتقان؟ (100% إتمام و 100% دقة)
  bool get isMasterMode => completionRate >= 100 && accuracyRate >= 100;

  @override
  String toString() {
    return '''
QuestionStats(
  إجمالي: $totalQuestions
  جديدة: $newQuestions
  مجابة: $answeredQuestions
  صحيحة: $correctAnswers
  خاطئة: $incorrectAnswers
  متبقية: $remainingQuestions
  نسبة الإتمام: ${completionRate.toStringAsFixed(1)}%
  نسبة الدقة: ${accuracyRate.toStringAsFixed(1)}%
)''';
  }
}
