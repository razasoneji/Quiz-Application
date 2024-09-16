import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QesutionNo 1'),
      ),
      body : Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child : Column(
            children: <Widget>[
              Text(
                'who is the current captian of team india ?',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to quiz page
                  print("option 1");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: Text('Rahul dravid'),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to quiz page
                  print("option 2");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                child: Text('MS Dhoni'),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to quiz page
                  print("option 3");

                },

                child: Text('Rohit sharma'),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to quiz page
                  print("option 4");

                },
                child: Text('virat kohli'),
              ),

            ],
          )
        ),

      )
    );
  }
}
