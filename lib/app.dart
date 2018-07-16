import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/Screen/login_screen.dart';

class App extends StatelessWidget {
  final appRoutes = <String, WidgetBuilder>{
    LoginScreen.name: (context) => LoginScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      routes: appRoutes,
      home: LoginScreen(),
    );
  }

}