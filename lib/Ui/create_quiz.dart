import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Ui/add_question.dart';
import 'package:quizapp/models/quiz.dart';
import 'package:quizapp/services/quiz_service.dart';
import 'package:quizapp/shared_widgets/appbar.dart';
import 'package:quizapp/shared_widgets/button.dart';
import 'package:quizapp/shared_widgets/dialog.dart';

class CreateQuiz extends StatefulWidget {
  @override
  CreateQuizState createState() => CreateQuizState();
}

class CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  Quiz quiz = Quiz();
  String quizId = "";
  void quizCreationHandler() async
  {
    if(_formKey.currentState!.validate()){
      //add the quiz object to the database 
      try {
        quiz.createdBy = FirebaseAuth.instance.currentUser!.uid;
        String quizId = await addQuiz(quiz);
        redirectDialogBox(context, "Quiz added succesfully Click on ok to add Questions", AddQuestion(quizId: quizId,));
      }
      catch(e)
      {
         errorDialogBox(context,e.toString() );
      }
    }
    // form is invalid so return 
    return ;

    
  }
  @override
  Widget build(BuildContext context) {
       // ignore: deprecated_member_use
   
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter image url for quiz (optional)",
                        ),
                        onChanged: (val) => {quiz.ImageUrl = val},
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz name" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Name",
                        ),
                        onChanged: (val) => {quiz.Name = val},
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Description" : null,
                        decoration: InputDecoration(
                          hintText: "Description",
                        ),
                        onChanged: (val) => {quiz.Description = val},
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty
                            ? "Enter time duration "
                            : null,
                        decoration: InputDecoration(
                          hintText: "time duration",
                        ),
                        keyboardType: TextInputType
                            .number, // Ensures that the input is a number
                        onChanged: (val) {
                          quiz.timeDuration = int.tryParse(val) ?? 30;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                      child: Button(context, "Create"),
                      onTap:() => quizCreationHandler(),)
                    ],
                  ),
                ))));
  }
}
