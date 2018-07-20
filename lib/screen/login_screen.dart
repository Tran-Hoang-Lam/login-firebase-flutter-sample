import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_firebase_flutter_example/model/user.dart';
import 'package:login_firebase_flutter_example/screen/home_screen.dart';
import 'package:login_firebase_flutter_example/screen/register_screen.dart';
import 'package:login_firebase_flutter_example/service/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  static const String name = "/loginScreen";

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  User user;
  AuthenticationService authenticationService = AuthenticationService();
  bool showLoadingIcon;

  @override
  void initState() {
    super.initState();
    user = User();
    showLoadingIcon = false;
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

  Widget emailInputText() => Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: TextFormField(
        onSaved: (value) => user.email = value,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ));

  Widget passwordInputText() => Padding(
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

  Widget loginButton() => Padding(
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

  Widget registerText() => FlatButton(
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.name),
      );

  void doLogin() {
    formKey.currentState.save();
    formKey.currentState.reset();

    setState(() {
      showLoadingIcon = true;
    });

    authenticationService.verifyUser(user).then((user) {
      Navigator
          .of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen(user)));
    }).catchError((error) {
      print(error);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Login Fail!!! ' + error.message),
        duration: Duration(seconds: 3),
      ));
    });
  }

  Widget buildbody() {
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
                  logo,
                  emailInputText(),
                  passwordInputText(),
                  loginButton(),
                  registerText()
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, body: buildbody());
  }
}
