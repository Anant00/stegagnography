import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stegagnography/src/demo.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.


    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDrW5Jf4alnyWyQkutdHPzgsNqjd7C8gVE",
      authDomain: "stagno-71ae1.firebaseapp.com",
      databaseURL: "https://stagno-71ae1-default-rtdb.firebaseio.com",
      projectId: "stagno-71ae1",
      storageBucket: "stagno-71ae1.appspot.com",
      messagingSenderId: "280924138784",
      appId: "1:280924138784:web:6a96613020de632eedfb45"
    )
  );
  runApp(DemoApp());
}
