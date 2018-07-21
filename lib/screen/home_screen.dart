import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/app.dart';
import 'package:login_firebase_flutter_example/resources/common_resource.dart';
import 'package:login_firebase_flutter_example/service/authentication_service.dart';

class HomeScreen extends StatelessWidget {
  static final String name = '/homeScreen';
  FirebaseUser user;

  HomeScreen(FirebaseUser user) {
    this.user = user;
  }

  Widget infoText(String info) => Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
        info == null ? 'N/A' : info,
        style: TextStyle(color: Colors.white),
      ));

  Widget logoutButton(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            elevation: 5.0,
            color: Colors.blue,
            onPressed: () {
              AuthenticationService.firebaseAuth.signOut().then((value) {
                Navigator.of(context).pushNamed(App.main_page);
              });
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          decoration: new BoxDecoration(image: CommonResource.backgroundImage),
          child: Center(
            child: Column(
              children: <Widget>[
                CommonResource.logo(user.photoUrl),
                infoText(user.uid),
                infoText(user.displayName),
                infoText(user.email),
                logoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
