import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_firebase_flutter_example/model/user.dart';
import 'package:login_firebase_flutter_example/resources/common_resource.dart';
import 'package:login_firebase_flutter_example/screen/home_screen.dart';
import 'package:login_firebase_flutter_example/service/authentication_service.dart';
import 'package:login_firebase_flutter_example/service/firebase_service.dart';

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
  Future<File> image;

  Image currentAvatar = Image.asset('asset/blank_avatar.png');

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
      case 'Password':
        user.password = value;
        break;
    }
  }

  Widget avatarChooser() {
    return FutureBuilder<File>(
      future: image,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          currentAvatar = Image.file(snapshot.data);
        } else if (snapshot.error != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Fail to load image!!!'),
            duration: Duration(seconds: 3),
          ));
        }

        return imageViewer(currentAvatar);
      },
    );
  }

  Widget imageViewer(var displayImage) => Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
            child: Container(
          width: 150.0,
          height: 150.0,
          child: Material(
            color: Colors.transparent,
            child: MaterialButton(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: displayImage,
                ),
                onPressed: () {
                  setState(() {
                    image = ImagePicker.pickImage(source: ImageSource.gallery);
                  });
                }),
          ),
        )),
      );

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
        decoration: new BoxDecoration(image: CommonResource.backgroundImage),
        child: Center(
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  avatarChooser(),
                  inputText('Display Name', false),
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
    setState(() {
      showLoadingIcon = true;
    });

    formKey.currentState.save();

    authenticationService.loginForUpload().then((user){
      image.then((imageFile){
        FirebaseService.uploadFile(imageFile).then((imageUrl){
          this.user.photoUrl = imageUrl;
          authenticationService.createUser(this.user).then((user) {
            Navigator
                .of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen(user)));
          }).catchError((error){
            handleException(error, "Register Fail!!!");
          });
        }).catchError((error){
          handleException(error, "Upload Fail!!!");
        });
      }).catchError((error){
        handleException(error, "Get image Fail!!!");
      });
    }).catchError((error){
      handleException(error, "Login for upload Fail!!!");
    });
  }

  void handleException(error, String message) {
    print(error.toString());
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
    setState(() {
      showLoadingIcon = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, body: buildBody());
  }
}
