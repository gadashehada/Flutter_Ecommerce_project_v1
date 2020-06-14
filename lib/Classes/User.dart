import 'package:project_ecommerce_v2/DBHelper.dart';

class User {
  String email;
  String password;
  String type;
  String name;
  String id;

  User({this.email , this.password , this.name , this.type , this.id});

  factory User.fromJson(Map<String , dynamic> json){
    return User(
      id: json[DBHelper.userId],
      email: json[DBHelper.userEmail],
      password: json[DBHelper.userPassword],
      name: json[DBHelper.userName],
      type: json[DBHelper.userType],);
  }

  Map<String , dynamic> toMap(String userId){
    return {
      DBHelper.userId : userId ,
      DBHelper.userEmail : this.email ,
      DBHelper.userName : this.name ,
      DBHelper.userType : this.type
    };
  }
}