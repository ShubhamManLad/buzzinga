// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:buzzinga/screens/enter_screen.dart';
import 'package:buzzinga/screens/splash_screen.dart';
import 'package:buzzinga/styles/constants.dart';
import 'package:buzzinga/widgets/chatroom_list.dart';
import 'package:buzzinga/widgets/user_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class Home_Screen extends StatefulWidget {

  static const String id = 'Home_Screen';

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {

  User? user;
  int pageIndex = 0;

  Widget loadPage(){
    if (pageIndex == 0){
      return UserList();
    }
    else if(pageIndex == 1){
      return ChatRoomList();
    }
    else {
      return Text('$pageIndex');
    }
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  void checkUser() async{
    user = await FirebaseAuth.instance?.currentUser;
    if (user==null){
      print('user not found');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Enter_Screen()));
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: loadPage(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.white,
              color: primaryColor,
              buttonBackgroundColor: primaryColor,
              items: [
                CurvedNavigationBarItem(
                  child: Icon(Icons.search),
                  label: 'Explore',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.chat_bubble_outline),
                  label: 'Chat',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.person_2),
                  label: 'Profile',
                  //https://ui-avatars.com/
                ),
              ],
              onTap: (index) {
                setState(() {
                  pageIndex = index;
                  print(pageIndex);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}






// return StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance.collection('users').snapshots(),
//     builder: (context, snapshot){
//       final users = snapshot.data;
//       List<Text> userItems = [];
//       if(users!=null) {
//         print('here');
//         for (var user in users.docs) {
//           userItems.add(Text(user['name']));
//           print(user['name']);
//         }
//       }
//       return Expanded(
//         child: ListView(
//           children: userItems,
//         ),
//
//       );
//     }
// );
// return ListView(
//   children: [Text('heelo')],
// );
