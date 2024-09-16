import "package:flutter/material.dart";
// import "package:quizapp/Ui/HomePage.dart";
import "package:quizapp/shared_widgets/appbar.dart";
import "package:quizapp/services/auth_services/auth.dart";
// import "package:quizapp/Ui/HomePage.dart";
import "package:quizapp/Ui/sign_up.dart";
import "package:quizapp/shared_widgets/button.dart";
import "package:quizapp/shared_widgets/dialog.dart";



class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  void signInHandler() async {
       if(_formKey.currentState!.validate())
       {
        final AuthService authService = AuthService();
       try {
        await authService.signInWithEmailPassword(email!, password!);
       }
       catch (e) {
        errorDialogBox(context, e.toString());
       }
       }  
       return ;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns widgets to the start
              children: [
                SizedBox(height: 50), // Adding space from the top
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter email" : null;
                  },
                  decoration: const InputDecoration(hintText: "Email"),
                  onChanged: (val) => email = val,
                ),
                SizedBox(height: 7),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter password" : null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                  onChanged: (val) => password = val,
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                     signInHandler();
                  },
                  child: Button(context,"Sign in")
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 15, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 60), // Adjust as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
