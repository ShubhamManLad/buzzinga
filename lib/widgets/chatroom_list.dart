import 'package:buzzinga/screens/chat_screen.dart';
import 'package:buzzinga/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:buzzinga/models/user_model.dart';
import 'package:buzzinga/models/chatroom_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatRoomList extends StatefulWidget {

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  late Future<List<ChatRoom_Model>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureData,
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done && snapshot.data!=null){
            List<ChatRoom_Model> chatrooms = snapshot.data!;
            return ListView.builder(
                itemCount: chatrooms.length,
                itemBuilder: (context, index){
                  dynamic? currentUserID = FirebaseAuth.instance.currentUser?.email;
                  String name1 = chatrooms[index].participants[0];
                  String name2 = chatrooms[index].participants[1];
                  return GestureDetector(
                    onTap: (){
                      //Navigator.pushNamed(context, Chat_Screen(chatRoomID:chatrooms[index].id ));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat_Screen(chatRoomID: chatrooms[index].id,)));
                    },
                    child: ChatRoom_Item(
                      name: currentUserID==name1?name2:name1,
                    ),
                  );
                }
            );
          }
          else{
            return Text('No data');
          }
        }
    );
  }
}

class ChatRoom_Item extends StatelessWidget {

  late String name;
  ChatRoom_Item({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            child: Icon(Icons.person),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 2)
                ),
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 25),
                )
            ),
          ),
        ],
      ),
    );
  }
}


Future<List<ChatRoom_Model>> fetchData() async {
  try {
    CollectionReference ref = FirebaseFirestore.instance.collection('chatrooms');
    var data = await ref.get();
    dynamic? currentUserID = await FirebaseAuth.instance.currentUser?.email;
    List<ChatRoom_Model> chatrooms = [];
    data.docs.forEach((chatroom) {
      ChatRoom_Model chatroom_item = ChatRoom_Model.fromMap(chatroom.data() as Map<String, dynamic>);
      if(chatroom_item.participants.contains(currentUserID)) {
        chatrooms.add(chatroom_item);
      }
    });
    return chatrooms;
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }

}
