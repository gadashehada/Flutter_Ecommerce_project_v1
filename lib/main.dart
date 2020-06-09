import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Auth/login.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
  

}

class MyAppState extends State<MyApp>{

@override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}
