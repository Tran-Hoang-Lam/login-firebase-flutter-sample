import 'package:firebase_database/firebase_database.dart';

class User {
  static const String collection_name = "users";

  String id;
  String name;
  String avatar;
  String password;
  DateTime dob;

  User(){
    name = '';
    avatar = '';
    password = '';
    dob = DateTime.now();
  }

  User.fromSnapshot (DataSnapshot snapshot) :
    id = snapshot.key,
    name = snapshot.value['name'],
    avatar = snapshot.value['avatar'],
    password = snapshot.value['password'],
    dob = DateTime.parse(snapshot.value['dob'])
  ;

  toJson () {
    return {
      'name' : name,
      'avatar' : avatar,
      'password' : password,
      'dob' : dob.toIso8601String()
    };
  }

}