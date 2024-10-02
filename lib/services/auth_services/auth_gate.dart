
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Ui/participant_home.dart'; // participant home page
import 'package:quizapp/Ui/admin_home.dart'; // admin home page
import 'package:quizapp/Ui/sign_in.dart';
import 'package:quizapp/services/user_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> _getHomePage(User? user) async {
    if (user == null) {
      return SignIn();
    }

    final email = user.email;
    if (email == null) {
      return SignIn();
    }


    final userModel = await findUserByEmail(email);

    if (userModel.role == 'UserRole.admin') {
      print("admin");
      return AdminHomePage(); 
    } else {
      print("participant");
      return ParticipantHomePage(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<Widget>(
              future: _getHomePage(snapshot.data),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (futureSnapshot.hasData) {
                  return futureSnapshot.data!;
                }

                return SignIn(); 
              },
            );
          }
          return SignIn();
        },
      ),
    );
  }
}