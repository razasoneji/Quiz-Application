import 'dart:convert';
import 'package:http/http.dart' as http;
Future<void> sendQuizCodeToParticipant(String email, String quizCode, String quizName) async {
  final url = Uri.parse('https://192.168.122.227:7000/send-quiz-code');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'quizCode': quizCode,
      'quizName': quizName,
    }),
  );

  if (response.statusCode == 200) {
    print('Quiz code sent successfully');
  } else {
    print('Failed to send quiz code');
  }
}
