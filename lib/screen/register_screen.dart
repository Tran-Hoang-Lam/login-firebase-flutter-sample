import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase_flutter_example/model/user.dart';
import 'package:login_firebase_flutter_example/screen/home_screen.dart';
import 'package:login_firebase_flutter_example/service/authentication_service.dart';

class RegisterScreen extends StatefulWidget {
  static final String name = '/registerScreen';

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  User user;
  AuthenticationService authenticationService = AuthenticationService();
  bool showLoadingIcon;

  DecorationImage backgroundImage = DecorationImage(
      image: ExactAssetImage('asset/blur-background-6z-800x1280.jpg'),
      fit: BoxFit.cover);

  @override
  void initState() {
    super.initState();
    user = User();
    showLoadingIcon = false;
  }

  saveValue(String value, String attribute) {
    switch (attribute) {
      case 'Email':
        user.email = value;
        break;
      case 'Display Name':
        user.displayName = value;
        break;
      case 'Photo URL':
        user.photoUrl = value;
        break;
      case 'Password':
        user.password = value;
        break;
    }
  }

  Widget inputText(String hintText, bool hideCharacter) => Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: TextFormField(
        onSaved: (value) => saveValue(value, hintText),
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        obscureText: hideCharacter,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ));

  Widget saveButton(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            elevation: 5.0,
            color: Colors.blue,
            onPressed: () {
              doRegist();
            },
            child: Text(
              'Regist',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  Widget buildBody() {
    if (showLoadingIcon) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        decoration: new BoxDecoration(image: backgroundImage),
        child: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  inputText('Display Name', false),
                  inputText('Photo URL', false),
                  inputText('Email', false),
                  inputText('Password', true),
                  saveButton(context),
                ],
              )),
        ),
      ),
    );
  }

  void doRegist() {
    formKey.currentState.save();

    setState(() {
      showLoadingIcon = true;
    });

    authenticationService.createUser(user).then((user) {
      Navigator
          .of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen(user)));
    }).catchError((error) {
      print(error);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Register Fail!!! ' + error.message),
        duration: Duration(seconds: 3),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, body: buildBody());
  }
}
