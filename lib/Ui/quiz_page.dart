import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/models/result.dart'; 

class QuizPage extends StatefulWidget {
  final Quiz quizData;
  final String quizDocumentId;

  QuizPage({required Map<String, dynamic> quizMap , required this.quizDocumentId })
      : quizData = Quiz.fromMap(quizMap);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  Map<int, dynamic> _answers = {};
  int _score = 0;
  late int _remainingTime; 
  late Timer _timer;
  List<Question> get questions => widget.quizData.questions;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.quizData.timeDuration * 60; // Convert minutes to seconds
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          _submitQuiz(); 
        }
      });
    });
  }

  void _submitQuiz() async {
    _calculateScore();
    _timer.cancel(); 
  
    final user = FirebaseAuth.instance.currentUser;
    Result result = Result(
      quizId: widget.quizDocumentId, 
      participantId: user!.uid, 
      score: _score,
      totalQuestions: questions.length,
    );
    await FirebaseFirestore.instance.collection('results').add(result.getMap());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Text('Your score: $_score/${questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
}


  void _calculateScore() {
    _score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswerIndex == _answers[i]) {
        _score++;
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[_currentQuestionIndex];
         // ignore: deprecated_member_use
         return WillPopScope(
    onWillPop: () async {
      return false; 
    },
     child: Scaffold(
      appBar: AppBar(
        title: Text(widget.quizData.Name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${questions.length}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ...currentQuestion.options.asMap().entries.map<Widget>((entry) {
              int optionIndex = entry.key;
              String option = entry.value;

              return RadioListTile(
                title: Text(option),
                value: optionIndex,
                groupValue: _answers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _answers[_currentQuestionIndex] = value;
                  });
                },
              );
            }).toList(),
            Spacer(),
            Text(
              'Time Remaining: ${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_currentQuestionIndex < questions.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                } else {
                  _submitQuiz();
                }
              },
              child: Text(
                _currentQuestionIndex == questions.length - 1
                    ? 'Submit Quiz'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
