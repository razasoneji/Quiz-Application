import 'package:flutter/material.dart';
import 'package:quizapp/Ui/quiz_page.dart';
import 'package:quizapp/services/auth_services/auth.dart';
import 'package:quizapp/utils/constants.dart';
// import 'package:quizapp/Ui/sign_in.dart';

class ParticipantHomePage extends StatelessWidget {
  final AuthService auth = AuthService();
  void logout() async
  {
    await auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Quiz App'),
            Spacer(),
            Icon(
              Icons.person
            ),
           GestureDetector(
            onTap: () {
                        logout();
                      },
            child : Icon(
              Icons.logout_sharp
            )) 
          ],
        )

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                 image:AssetImage(QUIZ_APP_ICON),
                 width:50.0,
                 height:50.0,
              ),
              Text('Welcome to the Quiz App!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text('Test your knowledge with our fun and interactive quizzes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to quiz page
                  print("btn is pressed");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
