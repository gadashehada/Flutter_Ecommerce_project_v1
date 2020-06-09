import 'package:flutter/material.dart';
import 'package:project_ecommerce_v1/Classes/User.dart';
import 'package:project_ecommerce_v1/DBHelper.dart';
import '../Auth/login.dart';

class CreateAccount extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
  }
}

class CreateAccountState extends State<CreateAccount>{

  String email;
  String name;
  String type;
  String pass;

  GlobalKey<FormState> formKey = GlobalKey();

  setEmail(String email){
  this.email = email;
}
  setName(String name){
  this.name = name;
}
  setType(String type){
  this.type = type;
}
  setPassword(String pass){
  this.pass = pass;
}

  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    User user = User.fromJson({
      DBHelper.userEmail: this.email ,
      DBHelper.userPassword: this.pass ,
      DBHelper.userName: this.name ,
      DBHelper.userType: this.type
    });
    await DBHelper.dbHelper.insertNewUser(user);

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context){
        return Login();
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // name
                  TextFormField(
                    decoration: InputDecoration(labelText: 'name'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'name is empty';
                      }
                    },
                    onSaved: (newValue){
                      setName(newValue);
                    },
                  ),
                  SizedBox(height: 20,), 
                  // email
                  TextFormField(
                    decoration: InputDecoration(labelText: 'email'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'email is empty';
                      }else if(!RegExp('[A-Za-z0-9._%-]+@[A-Za-z0-9._%-]+\.[A-Za-z]{2,4}').hasMatch(value)){
                        return 'Enter right email';
                      }
                    },
                    onSaved: (newValue){
                      setEmail(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // password
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'password is empty';
                      }else if(value.length < 6){
                        return 'password is short';
                      }
                    },
                    onSaved: (newValue){
                      setPassword(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // type
                  TextFormField(
                    decoration: InputDecoration(labelText: 'type'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'type is empty';
                      }else if(value != 'client' && value != 'merchant'){
                        return 'Enter right type (client or merchant)';
                      }
                    },
                    onSaved: (newValue){
                      setType(newValue);
                    },
                  ),
                  SizedBox(height: 50,),
                  // btn create account
                  Container(width: 300,color: Colors.blue,child: FlatButton(
                    onPressed: (){saveMyForm();},
                    child: Text('Create Account',style: TextStyle(color: Colors.white)),)),
                  SizedBox(height: 20,),
                  // go to login
                  InkWell(child: Center(child: Text("you already have account?? Login")),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return Login();
                        }));
                    },)
                ],
              ),
            )),
        ),
    );
  }
}
