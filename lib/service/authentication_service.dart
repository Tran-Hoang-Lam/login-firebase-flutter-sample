import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:login_firebase_flutter_example/configuration/application_configuration.dart';
import 'package:login_firebase_flutter_example/model/user.dart';

class AuthenticationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> verifyUser(User user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      return await firebaseAuth.currentUser();
    } catch (e) {
      e.toString();
      throw e;
    }
  }

  Future<FirebaseUser> loginFacebook() async {
    FacebookLogin facebookLogin = new FacebookLogin();
    FacebookLoginResult loginResult = await facebookLogin
        .logInWithReadPermissions(["email", "public_profile"]);
    FirebaseUser currentUser;
    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        currentUser = await firebaseAuth.signInWithFacebook(
            accessToken: loginResult.accessToken.token);
        break;
      case FacebookLoginStatus.error:
        throw new Exception(loginResult.errorMessage);
      case FacebookLoginStatus.cancelledByUser:
        throw new Exception('Canceled!!!');
    }

    return currentUser;
  }

  Future<FirebaseUser> createUser(User user) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName =
      user.displayName == null ? '' : user.displayName;
      userUpdateInfo.photoUrl = user.photoUrl == null ? '' : user.photoUrl;
      await firebaseAuth.updateProfile(userUpdateInfo);

      return await firebaseAuth.currentUser();
    } catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> loginForUpload() async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: ApplicationConfiguration.configMap['uploadUsername'],
          password: ApplicationConfiguration.configMap['uploadPassword']);
      return await firebaseAuth.currentUser();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}
