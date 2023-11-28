class User_Model{

  final String name;
  final String emailID;

  User_Model({
    required this.name,
    required this.emailID
  });

  factory User_Model.fromMap(Map<String,dynamic> data){
    return User_Model(name: data['name'], emailID: data['emailID']);
  }


}