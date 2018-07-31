import 'package:flutter/material.dart';
import 'package:login_firebase_flutter_example/configuration/application_configuration.dart';
import 'package:login_firebase_flutter_example/screen/login_screen.dart';
import 'package:login_firebase_flutter_example/screen/register_screen.dart';
import 'package:login_firebase_flutter_example/screen/reset_password_screen.dart';

class App extends StatelessWidget {
  static final String main_page = '/';

  final appRoutes = <String, WidgetBuilder>{
    main_page: (context) => LoginScreen(),
    LoginScreen.name: (context) => LoginScreen(),
    RegisterScreen.name: (context) => RegisterScreen(),
    ResetPasswordScreen.name: (context) => ResetPasswordScreen()
  };

  @override
  Widget build(BuildContext context) {
    ApplicationConfiguration();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      routes: appRoutes,
      initialRoute: main_page,
    );
  }
}
