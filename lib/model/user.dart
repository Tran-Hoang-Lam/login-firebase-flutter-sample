import 'package:firebase_database/firebase_database.dart';

class User {
  static const String collection_name = "users";

  String displayName;
  String email;
  String uid;
  String password;
  String photoUrl;

  User(){
    displayName = '';
    photoUrl = '';
    password = '';
    email = '';
  }
}