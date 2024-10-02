import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Ui/create_quiz.dart';
import 'package:quizapp/Ui/profile_page.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/services/auth_services/auth.dart';
import 'package:quizapp/shared_widgets/quiz_card.dart';
import 'package:quizapp/utils/constants.dart';

class AdminHomePage extends StatelessWidget {
  final AuthService auth = AuthService();

  void logout() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(QUIZ_COLLECTION)
            .where('createdBy', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
                child: Center(
                  child: Text(
                    "No Quizes found",
                    style : TextStyle(fontSize: 30,fontWeight: FontWeight.bold)
                  )),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot quizDoc = snapshot.data!.docs[index];
              Quiz quiz = Quiz.fromMap(quizDoc.data() as Map<String, dynamic>);
               String quizId = quizDoc.id;
              return QuizCard(quiz: quiz,quizId: quizId,);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateQuiz()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }
}
