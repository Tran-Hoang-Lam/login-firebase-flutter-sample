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
              projectID: 'user-database-ed222',
              gcmSenderID: '972682480781'))
      .then((app) {
    firebaseDatabase = FirebaseDatabase(
        app: app,
        databaseURL: ApplicationConfiguration.configMap['databaseURL']);
    firebaseStorage = FirebaseStorage(
        app: app,
        storageBucket: ApplicationConfiguration.configMap['storageBucket']);
  });

  FirebaseService.initDatabase() {
    firebaseApp;
  }

  static Future<String> uploadFile(File file) async {
    try {
      String path = file.path.substring(file.path.lastIndexOf("/") + 1);
      StorageUploadTask uploadTask =
          firebaseStorage.ref().child('images').child(path).putFile(file);

      UploadTaskSnapshot snapshot = await uploadTask.future;
      Uri downloadUri = snapshot.downloadUrl;
      return downloadUri.toString();
    } catch (error) {
      throw error;
    }
  }
}
