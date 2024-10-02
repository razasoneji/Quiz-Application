import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/models/result.dart';
import 'package:quizapp/models/user.dart';

class ResultsPage extends StatelessWidget {
  final String quizId;

  ResultsPage({required this.quizId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('results')
            .where('quizId', isEqualTo: quizId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No results found for this quiz.'));
          }

          List<DocumentSnapshot> resultDocs = snapshot.data!.docs;

          return FutureBuilder<List<User>>(
            future: fetchParticipantDetails(resultDocs),
            builder: (context, participantSnapshot) {
              if (!participantSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<User> participants = participantSnapshot.data!;

              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    height: MediaQuery.of(context).size.height * 0.6, 
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), 
                        ),
                      ],
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            'Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Score',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        resultDocs.length,
                        (index) {
                          Result result = Result.fromMap(
                              resultDocs[index].data() as Map<String, dynamic>);
                          User participant = participants[index];

                          return DataRow(
                            cells: [
                              DataCell(Text(
                                participant.name,
                                style: TextStyle(fontSize: 16),
                              )),
                              DataCell(Text(
                                '${result.score}/${result.totalQuestions}',
                                style: TextStyle(fontSize: 16),
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Future<List<User>> fetchParticipantDetails(List<DocumentSnapshot> resultDocs) async {
    List<Future<User>> futures = resultDocs.map((resultDoc) async {
      Result result = Result.fromMap(resultDoc.data() as Map<String, dynamic>);
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(result.participantId)
          .get();
      return User.fromMap(userDoc.data() as Map<String, dynamic>);
    }).toList();

    return Future.wait(futures);
  }
}

