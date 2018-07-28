import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:login_firebase_flutter_example/service/firebase_service.dart';

class ApplicationConfiguration {
  static Map configMap;

  Future<String> loadJsonFile() async {
    return await rootBundle.loadString('config.json');
  }

  ApplicationConfiguration() {
    loadJsonFile().then((jsonContent) {
      configMap = json.decode(jsonContent);
      FirebaseService().initDatabase();
    });
  }
}
