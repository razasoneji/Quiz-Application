import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/models/result.dart';

class QuizDetailsPage extends StatefulWidget {
  final Quiz quiz;
  final Result result;

  QuizDetailsPage({required this.quiz, required this.result});

  @override
  _QuizDetailsPageState createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  String? creatorName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCreatorName();
  }

  // Fetch creator's name from Firestore using the creatorId
  Future<void> fetchCreatorName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.quiz.createdBy)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          creatorName = userSnapshot['name']; // Assuming the user's name is stored under 'name'
          isLoading = false;
        });
      } else {
        setState(() {
          creatorName = 'Unknown Creator';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        creatorName = 'Error fetching creator';
        isLoading = false;
      });
    }
  }

  
  String calculateAccuracy() {
    if (widget.result.totalQuestions == 0) return "0%";
    double accuracy = (widget.result.score / widget.result.totalQuestions) * 100;
    return accuracy.toStringAsFixed(2) + "%";
  }

 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching the creator's name
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Quiz Name
                  Text(
                    widget.quiz.Name,
                    style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),

                  // Quiz Description
                  Text(
                    widget.quiz.Description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),

                  // Creator Name
                  Text(
                    'Created by: $creatorName',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20.0),

                  // Score
                  Row(
                    children: [
                      Text(
                        'Your Score: ',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.result.score}/${widget.result.totalQuestions}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),

                  // Accuracy
                  Row(
                    children: [
                      Text(
                        'Accuracy: ',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        calculateAccuracy(),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),

                  // Date when the quiz was taken
                  Row(
                    children: [
                      Text(
                        'Date Taken: ',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' ${widget.result.timestamp.weekday} - ${widget.result.timestamp.month} - ${widget.result.timestamp.year}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),

                  // Optionally, you could add more details like question-level performance here

                  Spacer(),

                  // Back Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                      child: Text('Go Back'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
