import 'dart:async';
import 'package:buzzinga/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buzzinga/screens/enter_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash_Screen extends StatefulWidget {

  static const String id = 'splash_screen';

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance?.currentUser;
    if (user== null){
      print('user found');
      Navigator.pushNamed(context, Enter_Screen.id);
    }
    Timer(
      Duration(seconds: 3),
        ()=>Navigator.push(context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 2),
                pageBuilder: (_, __, ___) => Home_Screen(),)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFAE1E25),
          body: Center(
            child: Row(
              children: [
                Expanded(
                    child: Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('images/logo.png'),
                        width: 200,
                        height: 200,
                      ),
                    )
                ),
                Expanded(
                    child: Hero(
                      tag: 'title',
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Buzzinga',
                            textStyle: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
                            speed: Duration(milliseconds: 100),
                          )
                        ],
                        totalRepeatCount: 1,
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
