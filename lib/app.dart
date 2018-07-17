import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/screen/login_screen.dart';
import 'package:login_firebase_flutter_example/service/firebase_service.dart';

class App extends StatelessWidget {
  final appRoutes = <String, WidgetBuilder>{
    LoginScreen.name: (context) => LoginScreen()
  };

  @override
  Widget build(BuildContext context) {
    FirebaseService.initDatabase();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      routes: appRoutes,
      home: LoginScreen(),
    );
  }

}