import 'package:buzzinga/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:buzzinga/screens/splash_screen.dart';
import 'package:buzzinga/screens/enter_screen.dart';
import 'package:buzzinga/screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: Home_Screen.id,
        routes: {
          Splash_Screen.id: (context) => Splash_Screen(),
          Enter_Screen.id: (context) => Enter_Screen(),
          Home_Screen.id: (context) => Home_Screen(),
        }
    );
  }
}

