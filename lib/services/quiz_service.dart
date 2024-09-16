import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quizapp/models/question.dart';
import 'package:quizapp/models/quiz.dart';

import 'package:quizapp/utils/constants.dart';
import 'package:quizapp/utils/db.dart';

Future<String> addQuiz(Quiz quiz) async {
  try {
    DocumentReference docRef =
        await db.collection(QUIZ_COLLECTION).add(quiz.getMap());
    String quizId = docRef.id;
    return quizId; // Return the quizId
  } catch (e) {
    throw e; // Re-throw the exception if something goes wrong
  }
}

addQuestionsToQuiz(List<Question> questionList, String quizId) async {
  var quizDocRef = FirebaseFirestore.instance.collection(QUIZ_COLLECTION).doc(quizId);
  try {
    var quizSnapshot = await quizDocRef.get();
    if (quizSnapshot.exists) {
      var quizData = quizSnapshot.data() as Map<String, dynamic>;
      List<dynamic> existingQuestions = quizData['questions'] ?? [];
      List<Map<String, dynamic>> updatedQuestions = existingQuestions
          .cast<Map<String, dynamic>>()
        ..addAll(questionList.map((question) => question.getMap()));
      await quizDocRef.update({'questions': updatedQuestions});
    } else {
      return;
    }
  } catch (e) {
    throw e;
  }
}
