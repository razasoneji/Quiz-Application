import 'package:quizapp/models/question.dart';
class Quiz {
  String ImageUrl = "";
  String Name ="";
  String Description ="";
  int timeDuration=30; 
  List<Question> questions = [];
  String createdBy = "";
  Quiz();
  Map<String,dynamic> getMap()
  {
    return  <String, dynamic>{
          'imageUrl': ImageUrl,
          'name': Name,
          'description': Description,
          'timeDuration': timeDuration,
          'questions': questions.map((question) => question.getMap()).toList(),
          'createdBy': createdBy,
    };
  }
    Quiz.fromMap(Map<String, dynamic> data) {
    ImageUrl = data['imageUrl'] ?? '';
    Name = data['name'] ?? '';
    Description = data['description'] ?? '';
    timeDuration = data['timeDuration'] ?? 30;
    createdBy = data['createdBy'] ?? '';
    if (data['questions'] != null) {
      questions = List<Question>.from(
        data['questions'].map((item) => Question.fromMap(item))
      );
    }
  }
  
}
