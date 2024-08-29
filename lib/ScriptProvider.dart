// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class ScriptProvider with ChangeNotifier {
//   String _scriptContent = "Press the button to load the script";

//   String get scriptContent => _scriptContent;

//   Future<void> loadPythonScript() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/lib/python_files/app.py');
//       _scriptContent = await file.readAsString();
//     } catch (e) {
//       _scriptContent = 'Error loading script: $e';
//     }
//     notifyListeners();
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ScriptProvider with ChangeNotifier {
  String _scriptContent = "Press the button to load the script";

  String get scriptContent => _scriptContent;

  Future<void> loadPythonScript() async {
    try {
      _scriptContent = await rootBundle.loadString('assets/app.py');
    } catch (e) {
      _scriptContent = 'Error loading script: $e';
    }
    notifyListeners();
  }
}
