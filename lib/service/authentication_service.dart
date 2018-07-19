import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_firebase_flutter_example/model/user.dart';

class AuthenticationService {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser currentUser;

  Future<FirebaseUser> verifyUser (User user) async {
    try {
      currentUser = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      return currentUser;
    } catch (e) {
      e.toString();
      throw e;
    }
  }

  Future<FirebaseUser> createUser (User user) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = user.displayName == null ? '' : user.displayName;
      userUpdateInfo.photoUrl = user.photoUrl == null ? '' : user.photoUrl;
      await firebaseAuth.updateProfile(userUpdateInfo);

      currentUser = await firebaseAuth.currentUser();
      return currentUser;
    } catch (e) {
      throw e;
    }
  }

}