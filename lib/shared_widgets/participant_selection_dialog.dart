import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/models/user.dart';
import 'package:quizapp/services/email_service.dart';


class ParticipantSelectionDialog extends StatefulWidget {
  final String quizId;
  final String quizName;

  ParticipantSelectionDialog({required this.quizId,required this.quizName});

  @override
  _ParticipantSelectionDialogState createState() => _ParticipantSelectionDialogState();
}

class _ParticipantSelectionDialogState extends State<ParticipantSelectionDialog> {
  List<User> participants = [];
  Set<String> selectedParticipants = {};

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  void fetchParticipants() async {
    
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user') 
        .where('role', isEqualTo: 'UserRole.participant') 
        .get();

    setState(() {
      participants = snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> sendQuizCode() async {
    print("sending the email >>>>>>>>>>>>>");
  for (String email in selectedParticipants) {
     await sendQuizCodeToParticipant(email,widget.quizId,widget.quizName);
  }
  Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Participants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                User user = participants[index];
                return CheckboxListTile(
                  title: Text(user.name),
                  value: selectedParticipants.contains(user.email),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedParticipants.add(user.email);
                      } else {
                        selectedParticipants.remove(user.email);
                      }
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: sendQuizCode,
            child: Text('Send Quiz Code'),
          ),
        ],
      ),
    );
  }
}
