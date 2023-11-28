import 'package:flutter/material.dart';
import 'package:buzzinga/styles/button_style.dart';
import 'package:buzzinga/styles/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:ant_design_flutter/ant_design_flutter.dart' as ant_design;

class Register_Container extends StatefulWidget {

  @override
  State<Register_Container> createState() => _Register_ContainerState();
}

class _Register_ContainerState extends State<Register_Container> {

  bool showPassword = true;

  late String name;
  late String emailID;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              name = value;
            },
            style: TextStyle(
              color: tertiaryColor,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
                labelText: 'Name',
                labelStyle:  TextStyle(
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

        //Email ID
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              emailID = value;
            },
            style: TextStyle(
              color: tertiaryColor,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
                labelText: 'Email ID',
                labelStyle:  TextStyle(
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
            onChanged: (value) {
                password = value;
                },
            style: TextStyle(
              color: tertiaryColor,
            ),
            obscureText: showPassword,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle:  TextStyle(
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
                  showPassword = !showPassword;
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
            UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailID, password: password);
            User? user = await FirebaseAuth.instance.currentUser;
            if(user!=null){
              await user?.updateDisplayName(name);
              var db = FirebaseFirestore.instance.collection('users');
              final data = <String, dynamic>{
                'name':name,
                'emailID':emailID
              };
              await db.add(data);

            }
          },
          child: Text(
              'Register',
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
