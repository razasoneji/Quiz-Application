
class Result {
  String quizId = "";
  String participantId = "";
  int score = 0;
  int totalQuestions = 0;
  DateTime timestamp;

  Result({required this.participantId, required this.quizId, required this.score, required this.totalQuestions})
      : timestamp = DateTime.now();

  Map<String, dynamic> getMap() {
    return {
      'quizId': quizId,
      'participantId': participantId,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Result.fromMap(Map<String, dynamic> data) 
      : quizId = data['quizId'] ?? '',
        participantId = data['participantId'] ?? '',
        score = data['score'] ?? 0,
        totalQuestions = data['totalQuestions'] ?? 0,
        timestamp = DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String());
}
