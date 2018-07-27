import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_firebase_flutter_example/configuration/application_configuration.dart';

class FirebaseService {
  static FirebaseDatabase firebaseDatabase;
  static FirebaseStorage firebaseStorage;

  final Future<FirebaseApp> firebaseApp = FirebaseApp
      .configure(
          name: 'db',
          options: FirebaseOptions(
              googleAppID: ApplicationConfiguration.configMap['googleAppID'],
              apiKey: ApplicationConfiguration.configMap['apiKey'],
              databaseURL: ApplicationConfiguration.configMap['databaseURL']))
      .then((app) {
    firebaseDatabase = FirebaseDatabase(app: app);
    firebaseDatabase.reference().child('');
    firebaseStorage = FirebaseStorage(
        app: app, storageBucket: 'gs://user-database-ed222.appspot.com');
  });

  FirebaseService.initDatabase() {
    firebaseApp;
  }

  static Future<String> uploadFile(File file) async {
    StorageUploadTask uploadTask = firebaseStorage
        .ref()
        .child('images')
        .child(file.path)
        .putFile(file, StorageMetadata(contentLanguage: 'en'));

    return (await uploadTask.future).downloadUrl.toString();
  }
}
