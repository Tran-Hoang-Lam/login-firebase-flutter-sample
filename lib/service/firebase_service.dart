import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_firebase_flutter_example/configuration/application_configuration.dart';

class FirebaseService {
  static FirebaseDatabase firebaseDatabase;
  static FirebaseStorage firebaseStorage;

  final Future<FirebaseApp> firebaseApp = FirebaseApp.configure(
      name: 'db',
      options: FirebaseOptions(
          googleAppID: ApplicationConfiguration.configMap['googleAppID'],
          apiKey: ApplicationConfiguration.configMap['apiKey'],
          projectID: 'user-database-ed222',
          gcmSenderID: '972682480781',
          storageBucket: ApplicationConfiguration.configMap['storageBucket'],
          databaseURL: ApplicationConfiguration.configMap['databaseURL']));

  initDatabase() {
    firebaseApp.then((app) {
      firebaseDatabase = FirebaseDatabase(app: FirebaseApp(name: 'db'));
      firebaseStorage = FirebaseStorage(app: FirebaseApp(name: 'db'));
    });
  }

  static Future<String> uploadFile(File file) async {
    try {
      if (!file.path.startsWith("asset")) {
        String path = file.path.substring(file.path.lastIndexOf("/") + 1);
        StorageUploadTask uploadTask =
            firebaseStorage.ref().child('images').child(path).putFile(file);

        UploadTaskSnapshot snapshot = await uploadTask.future;
        Uri downloadUri = snapshot.downloadUrl;
        return downloadUri.toString();
      } else {
        return '';
      }
    } catch (error) {
      throw error;
    }
  }
}
