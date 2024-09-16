import "package:flutter/material.dart";
import "package:quizapp/services/auth_services/auth_gate.dart";
// import "package:quizapp/Ui/HomePage.dart";

import "package:quizapp/shared_widgets/appbar.dart";
import "package:quizapp/services/auth_services/auth.dart";
import "package:quizapp/Ui/sign_in.dart";
import "package:quizapp/shared_widgets/button.dart";
import "package:quizapp/shared_widgets/dialog.dart";

enum UserRole { admin, participant }

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email="", password="", confirmPassword="", name="";
  UserRole _selectedRole = UserRole.admin;
 bool validate_form()
 {
   if(_formKey.currentState!.validate())
   {
     return true;
   }
   return false;
 }
  
  void signUpHandler() async {
        if(password != confirmPassword) 
        {
          errorDialogBox(context, "Password and Confirm Password should be the same");
          return;
        }
        if(password == confirmPassword && validate_form()) {
        final AuthService authService = AuthService();
        try {
          await authService.signUpWithEmailPassword(
              email, password, name, _selectedRole.toString());
          redirectDialogBox(context,
              "Sign up is successfull click on ok to continue", AuthGate());
        } catch (e) {
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
        // Wrap the entire content in SingleChildScrollView
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align the children to the start
              children: [
                SizedBox(height: 50), // Adjust spacing from the top

                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter email" : null;
                  },
                  decoration: const InputDecoration(hintText: "Email"),
                  onChanged: (val) => email = val,
                ),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter Name" : null;
                  },
                  decoration: const InputDecoration(hintText: "name"),
                  onChanged: (val) => name = val,
                ),
                SizedBox(height: 7),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter password" : null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                  onChanged: (val) =>
                      password = val, // Change to update the correct variable
                ),
                SizedBox(height: 7),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "confirm your password" : null;
                  },
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Confirm Password"),
                  onChanged: (val) => confirmPassword = val,
                ),
                SizedBox(height: 7),
                Text(
                  "Select your role",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 7),
                RadioListTile<UserRole>(
                  tileColor: Colors.blue[50],
                  title: const Text('Admin'),
                  value: UserRole.admin,
                  groupValue: _selectedRole,
                  onChanged: (UserRole? value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                RadioListTile<UserRole>(
                  tileColor: Colors.blue[50],
                  title: const Text('Participant'),
                  value: UserRole.participant,
                  groupValue: _selectedRole,
                  onChanged: (UserRole? value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                SizedBox(height: 25),
                GestureDetector(
                    onTap: () {
                      signUpHandler();
                    },
                    child: Button(context, "Sign Up")),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: const Text(
                        "Sign in",
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
