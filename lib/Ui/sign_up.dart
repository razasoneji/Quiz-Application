import "dart:io";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:quizapp/services/auth_services/auth_gate.dart";
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
  String email = "", password = "", confirmPassword = "", name = "";
  UserRole _selectedRole = UserRole.admin;
  XFile? _image; // Variable to hold the selected image

  bool validate_form() {
    return _formKey.currentState!.validate();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Allow the user to pick an image from the gallery
    _image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {}); // Update the UI to show the selected image
  }

 void signUpHandler() async {
  if (password != confirmPassword) {
    errorDialogBox(context, "Password and Confirm Password should be the same");
    return;
  }
  
  if (password == confirmPassword && validate_form()) {
    final AuthService authService = AuthService();
    try {
      // Step 1: Upload the image to Firebase Storage
      if (_image != null) {
        String fileName = _image!.name; 
        final storageRef = FirebaseStorage.instance.ref().child("profile_images/$fileName");
        await storageRef.putFile(File(_image!.path)); 

        print("getting the imageurl.......................................");
        String imageUrl = await storageRef.getDownloadURL();
        
      
        await authService.signUpWithEmailPassword(
            email, password, name, _selectedRole.toString(), imageUrl); 
        print("signing up.....................................................");
        redirectDialogBox(context,
            "Sign up is successful, click on OK to continue", AuthGate());
      } else {
        errorDialogBox(context, "Please select a profile picture.");
      }
    } catch (e) {
      errorDialogBox(context, e.toString());
    }
  }
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 20),

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
                  decoration: const InputDecoration(hintText: "Name"),
                  onChanged: (val) => name = val,
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
                SizedBox(height: 7),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Confirm your password" : null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Confirm Password"),
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
                  child: Button(context, "Sign Up"),
                ),
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
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
