import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';

//global object for firebase & media query size
late FirebaseAuth auth;
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //for setting preferred orientation to portrait
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) {
    //initializing firebase
    _initiateFirebase();
    //launching the application
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Auth',
      //load login screen as first screen of application
      home: LoginScreen(),
    );
  }
}

_initiateFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instance;
  //if already logged in then sign out
  auth.signOut();
}
