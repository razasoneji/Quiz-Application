import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/models/user.dart';
import 'package:quizapp/utils/constants.dart';
import 'package:quizapp/utils/db.dart';

addUser(User user,String uid)
{
  // db.collection(USER_COLLECTION).add(user.getMap())
  // .then((DocumentReference doc)=> print("user added to db"));

  db.collection(USER_COLLECTION).doc(uid).set(user.getMap())
      .then((_) => print("User added to DB with UID: $uid"))
      .catchError((error) => print("Error adding user: $error"));

}
deleteUser(String email)
{

}
getUser()
{

}
updateUser(String email,User newUser)
{

}
Future<User> findUserByEmail(String email) async
{
   QuerySnapshot querySnapshot = await db.collection(USER_COLLECTION).where("email" , isEqualTo: email).get();
   DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    return User.fromMap(documentSnapshot.data() as Map<String, dynamic>);

}