import 'package:flutter/material.dart';
import 'package:buzzinga/models/user_model.dart';
import 'package:buzzinga/models/chatroom_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class UserList extends StatefulWidget {

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<User_Model>> futureData;

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
            List<User_Model> users = snapshot.data!;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index){
                  return User_Item(
                    name: users[index].name,
                    emailID: users[index].emailID,
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

class User_Item extends StatelessWidget {

  late String name,emailID;
  User_Item({required this.name,required this.emailID});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,style: TextStyle(fontSize: 25),),
              Text(emailID, style: TextStyle(fontSize: 25),),
            ],
          ),
          FloatingActionButton.small(
              onPressed: (){
                createChatroom(emailID);
              },
              child: Icon(Icons.add)
          )
        ],
      ),
    );
  }
}


Future<List<User_Model>> fetchData() async {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  var data = await ref.get();
  List<User_Model> users = [];
  data.docs.forEach((user) {
    User_Model user_item = User_Model.fromMap(user.data() as Map<String,dynamic>);
    if(user_item.emailID != FirebaseAuth.instance.currentUser?.email ) {
      users.add(user_item);
    }
  });
  return users;

}

void createChatroom (String user) async{
  String? currentUser = FirebaseAuth.instance.currentUser?.email;
  String id = '$currentUser:$user';
  // Check if chatroom already exists
  var db = FirebaseFirestore.instance.collection('chatrooms');
  List<String> chatrooms = [];
  await db.snapshots().forEach((element) {
    element.docs.forEach((chatroom) {
      chatrooms.add(chatroom.get('id'));
    });
  });
  if (!chatrooms.contains('$user:$currentUser')){
    final data = <String, dynamic>{
      'id':id,
      'participants':[currentUser, user],
    };
    await db.doc(id).set(data);
  }


}
