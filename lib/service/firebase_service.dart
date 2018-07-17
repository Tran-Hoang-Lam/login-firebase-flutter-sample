import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static FirebaseDatabase firebaseDatabase;

  final Future<FirebaseApp> firebaseApp = FirebaseApp.configure(
    name: 'db',
      options: FirebaseOptions(
          googleAppID: '1:972682480781:android:99f241b606307a18',
          apiKey: 'AIzaSyCs0ii_-8ZtRm1pl1uido-BQlF16KwyoyI',
          databaseURL: 'https://user-database-ed222.firebaseio.com')
  ).then((app){
    firebaseDatabase = FirebaseDatabase(app: app);
  });

  FirebaseService.initDatabase () {
    firebaseApp;
  }
}