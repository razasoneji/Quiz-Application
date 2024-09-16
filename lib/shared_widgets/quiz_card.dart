import 'package:flutter/material.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/utils/constants.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;


  QuizCard({required this.quiz,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("quiz card is clicked"),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 5,
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: quiz.ImageUrl.isNotEmpty
                      ? NetworkImage(quiz.ImageUrl)
                      : AssetImage(QUIZ_CARD_DEFAULT_BACKGROUND) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              height: 150,
            ),
            // Overlay with Quiz Information
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  quiz.Name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
