class ChatRoom_Model{

  final String id;
  final List<dynamic> participants;

  ChatRoom_Model({
    required this.id,
    required this.participants,
  });

  factory ChatRoom_Model.fromMap(Map<String, dynamic>data){
    return ChatRoom_Model(
        id: data['id'],
        participants: data['participants']
    );
  }

}