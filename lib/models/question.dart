class Question {
  String question="";
  List<String> options = [];
  int correctAnswerIndex=0;
  Question();
  Map<String,dynamic> getMap(){
    return <String,dynamic>{
        "question" : question,
        "options" : options,
        "correctAnswerIndex" : correctAnswerIndex
    };
  }
    Question.fromMap(Map<String, dynamic> data) {
    question = data['question'] ?? '';
    options = List<String>.from(data['options'] ?? []);
    correctAnswerIndex = data['correctAnswerIndex'] ?? 0;
  }
}

