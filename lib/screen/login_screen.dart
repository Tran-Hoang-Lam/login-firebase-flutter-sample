import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/model/user.dart';
import 'package:login_firebase_flutter_example/service/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  static const String name = "login-screen";

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static User user;

  @override
  void initState() {
    super.initState();
    user = User();
  }

  DecorationImage backgroundImage = DecorationImage(
      image: ExactAssetImage('asset/blur-background-6z-800x1280.jpg'),
      fit: BoxFit.cover);

  Widget logo = Padding(
      padding: EdgeInsets.only(top: 100.0, bottom: 20.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90.0,
        child: Image.asset('asset/flutter-logo-round.png'),
      ));

  Widget userNameInputText = Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: TextFormField(
        onSaved: (value) => user.name = value,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'User Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ));

  Widget passwordInputText = Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
      child: TextFormField(
        onSaved: (value) => user.password = value,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintStyle: TextStyle(color: Colors.white)),
      ));

  Widget loginButton(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            elevation: 5.0,
            color: Colors.blue,
            onPressed: () {
              doLogin();
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  Widget registerText = FlatButton(
    child: Text(
      'Register',
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () => debugPrint('Register pressed'),
  );

  void doLogin() {
    formKey.currentState.save();
    formKey.currentState.reset();

    DatabaseReference reference =  FirebaseService.firebaseDatabase
        .reference()
        .child(User.collection_name);

    print(reference.path);

    reference.orderByChild('name').equalTo(user.name).onChildAdded
        .listen
        ((snapshot) {
      if (snapshot.snapshot != null) {
        user = User.fromSnapshot(snapshot.snapshot);
        print(user.name);
        print(user.password);
        print(user.avatar);
        print(user.dob);
      }
    }, onError: (error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        decoration: new BoxDecoration(image: backgroundImage),
        child: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  logo,
                  userNameInputText,
                  passwordInputText,
                  loginButton(context),
                  registerText
                ],
              )),
        ),
      ),
    ));
  }
}
