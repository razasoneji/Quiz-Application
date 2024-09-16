import 'package:flutter/material.dart';
import 'package:quizapp/Ui/admin_home.dart';
import 'package:quizapp/models/question.dart';
import 'package:quizapp/services/quiz_service.dart';
import 'package:quizapp/shared_widgets/appbar.dart';
import 'package:quizapp/shared_widgets/button.dart';
import 'package:quizapp/shared_widgets/dialog.dart';

class AddQuestion extends StatefulWidget {
    final String quizId; 
    final List<Question> questionsList = [];
    AddQuestion({required this.quizId});
  @override
  AddQuestionState createState() => AddQuestionState();
}
class AddQuestionState extends State<AddQuestion>{
  final _formKey = GlobalKey<FormState>();
  String op1="",op2="",op3="",op4="";
  Question questionObj = Question();
  String correctAnswerIndex="0";
  void addQuestionHandler(){
        if (_formKey.currentState!.validate()) {
          questionObj.correctAnswerIndex = int.parse(correctAnswerIndex);
          questionObj.options = [op1, op2, op3, op4]; // Set the options for the current question
          widget.questionsList.add(questionObj);
      setState(() {
        // Add the current question to the list
        questionObj = Question(); // Create a new Question object for the next question
        correctAnswerIndex = "0"; // Reset the correct answer index
        _formKey.currentState!.reset();  // Reset the form for the next question
      });
    }
  }
  void submitQuestionsHandler() async {
       if (_formKey.currentState!.validate()) {
          questionObj.correctAnswerIndex = int.parse(correctAnswerIndex);
          questionObj.options = [op1, op2, op3, op4]; // Set the options for the current question
          widget.questionsList.add(questionObj);
       }
       else 
       {
        return ;
       }
    try {
       await addQuestionsToQuiz(widget.questionsList,widget.quizId);
      redirectDialogBox(context, "questions added successfully",AdminHomePage());
      return ;
    }
    catch(e)
    {
      errorDialogBox(context, e.toString());
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
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter the question" : null,
                  decoration: InputDecoration(hintText: "Question"),
                  onChanged: (val) => questionObj.question = val,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter option 1" : null,
                  decoration: InputDecoration(hintText: "Option 1"),
                  onChanged: (val) => op1=val,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter option 2" : null,
                  decoration: InputDecoration(hintText: "Option 2"),
                  onChanged: (val) => op2=val,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter option 3" : null,
                  decoration: InputDecoration(hintText: "Option 3"),
                  onChanged: (val) => op3=val,
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter option 4" : null,
                  decoration: InputDecoration(hintText: "Option 4"),
                  onChanged: (val) => op4=val,
                ),
                DropdownButtonFormField<String>(
                  value: correctAnswerIndex,
                  items: [
                    DropdownMenuItem(child: Text("Option 1"), value: "0"),
                    DropdownMenuItem(child: Text("Option 2"), value: "1" ),
                    DropdownMenuItem(child: Text("Option 3"), value: "2"),
                    DropdownMenuItem(child: Text("Option 4"), value: "3"),
                  ],
                  hint: Text("Select the correct option"),
                  onChanged: (val) {
                    setState(() {
                      correctAnswerIndex = val!;
                    });
                  },
                  validator: (val) =>
                      val == null ? "Select the correct option" : null,
                ),
                SizedBox(height: 50),
                GestureDetector(
                  child: Button(context, "Add Question"),
                  onTap: addQuestionHandler,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Button(context, "Submit"),
                  onTap: submitQuestionsHandler,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}