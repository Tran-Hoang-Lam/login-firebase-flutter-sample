import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_firebase_flutter_example/configuration/application_configuration.dart';

class FirebaseService {
  static FirebaseDatabase firebaseDatabase;

  final Future<FirebaseApp> firebaseApp = FirebaseApp.configure(
    name: 'db',
      options: FirebaseOptions(
          googleAppID: ApplicationConfiguration.configMap['googleAppID'],
          apiKey: ApplicationConfiguration.configMap['apiKey'],
          databaseURL: ApplicationConfiguration.configMap['databaseURL'])
  ).then((app){
    firebaseDatabase = FirebaseDatabase(app: app);
    firebaseDatabase.reference().child('');
  });

  FirebaseService.initDatabase () {
    firebaseApp;
  }
}