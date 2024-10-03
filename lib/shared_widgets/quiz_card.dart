import 'package:flutter/material.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/utils/constants.dart';
import 'package:quizapp/Ui/result_page.dart'; // Import ResultsPage
import 'package:quizapp/shared_widgets/participant_selection_dialog.dart'; // Import your participant selection dialog

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final String quizId;

  QuizCard({required this.quiz, required this.quizId}); 

  void selectParticipants(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ParticipantSelectionDialog(quizId: quizId,quizName: quiz.Name,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsPage(quizId: quizId)), // Pass the quiz ID here
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 5,
        child: Stack(
          children: [
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
            // Icon to select participants
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => selectParticipants(context),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  child: Icon(Icons.people, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
