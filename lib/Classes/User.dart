import 'package:project_ecommerce_v1/DBHelper.dart';

class User {
  String email;
  String password;
  String type;
  String name;
  int id;

  User({this.email , this.password , this.name , this.type , this.id});

  factory User.fromJson(Map<String , dynamic> json){
    return User(
      email: json[DBHelper.userEmail],
      password: json[DBHelper.userPassword],
      name: json[DBHelper.userName],
      type: json[DBHelper.userType],
      id: json[DBHelper.userId]);
  }

  Map<String , dynamic> toMap(){
    return {
      DBHelper.userEmail : this.email ,
      DBHelper.userPassword : this.password ,
      DBHelper.userName : this.name ,
      DBHelper.userType : this.type
    };
  }
}