import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Ui/profile_page.dart';
import 'package:quizapp/Ui/quiz_details_page.dart';
import 'package:quizapp/models/result.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/Ui/quiz_page.dart';
import 'package:quizapp/services/auth_services/auth.dart';
import 'package:quizapp/utils/constants.dart';

class ParticipantHomePage extends StatefulWidget {
  @override
  _ParticipantHomePageState createState() => _ParticipantHomePageState();
}

class _ParticipantHomePageState extends State<ParticipantHomePage> {
  final AuthService auth = AuthService();
  final TextEditingController _quizCodeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? errorMessage;

  void logout() async {
    await auth.signOut();
  }
  Stream<List<Result>> getUserQuizzes(String userId) {
    return firestore
        .collection('results')
        .where('participantId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Result.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
  Future<void> startQuiz(BuildContext context) async {
    String quizCode = _quizCodeController.text.trim();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (quizCode.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a quiz code.';
      });
      return;
    }

    try {
      
      QuerySnapshot resultSnapshot = await firestore
          .collection('results')
          .where('quizId', isEqualTo: quizCode)  
          .where('participantId', isEqualTo: userId)
          .get();

      if (resultSnapshot.docs.isNotEmpty) {
        setState(() {
          errorMessage = 'You have already participated in this quiz.';
        });
        return;
      }

    
      DocumentSnapshot quizSnapshot = await firestore.collection('quizes').doc(quizCode).get();

      if (quizSnapshot.exists) {
        String quizDocumentId = quizSnapshot.id;

        setState(() {
          errorMessage = null;
        });

        var quizData = quizSnapshot.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizPage(quizMap: quizData, quizDocumentId: quizDocumentId)),
        );
      } else {
        setState(() {
          errorMessage = 'No quiz found with this code.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching quiz: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
       // ignore: deprecated_member_use

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Quiz App'),
            Spacer(),
                        GestureDetector(
              onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  },

              child: Icon(Icons.person),
            ),
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Icon(Icons.logout_sharp),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(QUIZ_APP_ICON),
                  width: 50.0,
                  height: 50.0,
                ),
                Text(
                  'Welcome to the Quiz App!',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Test your knowledge with our fun and interactive quizzes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 40.0),
                TextField(
                  controller: _quizCodeController,
                  decoration: InputDecoration(
                    labelText: 'Enter Quiz Code',
                    border: OutlineInputBorder(),
                    errorText: errorMessage,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    startQuiz(context);
                  },
                  child: Text('Start Quiz'),
                ),
                SizedBox(height: 40.0),

                // Display list of quizzes user has participated in
                StreamBuilder<List<Result>>(
                  stream: getUserQuizzes(userId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text('No quizzes taken yet.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true, 
                      physics: NeverScrollableScrollPhysics(), 
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                      Result result = snapshot.data![index];

                        return FutureBuilder<DocumentSnapshot>(
                          future: firestore.collection('quizes').doc(result.quizId).get(),
                          builder: (context, quizSnapshot) {
                            if (!quizSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            Quiz quiz = Quiz.fromMap(quizSnapshot.data!.data() as Map<String, dynamic>);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizDetailsPage(
                                            quiz: quiz,
                                            result: result,
                                          )),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: ListTile(
                                  title: Text(quiz.Name),
                                  subtitle: Text('Score: ${result.score}/${result.totalQuestions}'),
                                  trailing: Icon(Icons.arrow_forward),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
