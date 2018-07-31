import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/resources/common_resource.dart';
import 'package:login_firebase_flutter_example/service/authentication_service.dart';
import 'package:validate/validate.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String name = '/resetPasswordScreen';

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> screenState = GlobalKey<ScaffoldState>();
  String resetEmail;

  @override
  void initState() {
    resetEmail = '';
  }

  void doSendMailReset() {
    if (formState.currentState.validate()) {
      formState.currentState.save();
      AuthenticationService().sendResetPasswordMail(resetEmail);
      screenState.currentState.showSnackBar(SnackBar(
        content: Text('Mail sended! Please check your mail box!!!'),
        duration: Duration(seconds: 10),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screenState,
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        decoration: new BoxDecoration(image: CommonResource.backgroundImage),
        child: Center(
            child: Form(
                key: formState,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, bottom: 5.0),
                      child: TextFormField(
                        onSaved: (value) => resetEmail = value,
                        validator: (value) {
                          if (value.isEmpty && !Validate.isEmail(value)) {
                            return 'Please input correct email';
                          }
                        },
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          elevation: 5.0,
                          color: Colors.blue,
                          onPressed: () {
                            doSendMailReset();
                          },
                          child: Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
      )),
    );
  }
}
