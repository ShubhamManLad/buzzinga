import 'package:ant_design_flutter/ant_design_flutter.dart' as ant_design;
import 'package:flutter/material.dart';
import 'package:buzzinga/styles/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat_Screen extends StatefulWidget {
  static const String id = 'Chat_Screen';

  late String chatRoomID;

  Chat_Screen({required this.chatRoomID});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  late String chatRoomID;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomID = widget.chatRoomID;
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return true; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {

    late String message;


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Message_List(
              chatRoomID: chatRoomID,
            ),
          ),

          // Bottom widget
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (value) {
                        message = value;
                    },
                    style: TextStyle(
                      color: tertiaryColor,
                    ),
                    cursorColor: Colors.orangeAccent,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      Map<String, dynamic> data = {
                        'sender': FirebaseAuth.instance.currentUser?.email,
                        'message': message,
                      };
                      String timestamp =
                          '${DateTime.now().millisecondsSinceEpoch}';
                      var db = await FirebaseFirestore.instance
                          .collection('messages');
                      await db
                          .doc('chatRooms')
                          .collection(chatRoomID)
                          .doc(timestamp)
                          .set(data);
                    },
                    icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message_List extends StatefulWidget {
  String chatRoomID;

  Message_List({required this.chatRoomID});

  @override
  State<Message_List> createState() => _Message_ListState();
}

class _Message_ListState extends State<Message_List> {
  late String chatRoomID;
  late String? userID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomID = widget.chatRoomID;
    userID = FirebaseAuth.instance.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc('chatRooms')
            .collection(chatRoomID)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Message_Item> messages_widget = [];
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          snapshot.data?.docs.reversed.forEach((message) {
            String m = message.get('message');
            String s = message.get('sender');
            bool isMe = false;
            if (s==userID){
              isMe=true;
            }
            messages_widget.add(Message_Item(message: m, isMe: isMe));
          });
          return ListView(
            reverse: true,
            children: messages_widget,
          );
        });
  }
}

class Message_Item extends StatelessWidget {
  String message;
  bool isMe;
  Message_Item({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isMe?Radius.circular(50):Radius.circular(0),
                topRight: isMe?Radius.circular(0):Radius.circular(50),
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
              border: Border.all(color: primaryColor),
              color: isMe?Colors.white:primaryColor,
            ),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
            ),
          ),
        ]
      ),
    );
  }
}
