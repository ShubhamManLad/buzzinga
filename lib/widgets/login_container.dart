import 'package:buzzinga/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buzzinga/styles/button_style.dart';
import 'package:buzzinga/styles/constants.dart';
import 'package:ant_design_flutter/ant_design_flutter.dart' as ant_design;

class Login_Container extends StatefulWidget {

  @override
  State<Login_Container> createState() => _Login_ContainerState();
}

class _Login_ContainerState extends State<Login_Container> {

  bool showPassword = true;

  late String emailID;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email ID
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              emailID = value;
            },
            style: TextStyle(
              color: tertiaryColor,
            ),
            cursorColor: Colors.orangeAccent,
            decoration: InputDecoration(
              labelText: 'Email ID',
              labelStyle: TextStyle(
                color: tertiaryColor,
              ),
              floatingLabelStyle: TextStyle(
                color: primaryColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              )
            ),
          ),
        ),

        // Password
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              password = value;
            },
            style: TextStyle(
              color: tertiaryColor,
            ),
            obscureText: showPassword,
            cursorColor: Colors.orangeAccent,
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: tertiaryColor,
                ),
                floatingLabelStyle: TextStyle(
              color: primaryColor,
            ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                suffix: GestureDetector(
                  onTap: (){
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: Icon(
                      showPassword ? Icons.visibility_off_outlined:Icons.visibility_outlined
                  ),
                )
            ),
          ),
        ),

        TextButton(
          onPressed: ()async{
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailID, password: password);
            print(await FirebaseAuth.instance.currentUser?.displayName);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_Screen()));
          },
          child: Text(
              'Login',
              style: TextStyle(
                color: tertiaryColor,
              )
          ),
          style: raisedButtonStyle,
        ),

      ],
    );
  }
}
