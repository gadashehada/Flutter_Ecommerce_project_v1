import 'package:flutter/material.dart';
import 'package:project_ecommerce_v2/DBHelper.dart';
import '../Classes/User.dart';
import '../Auth/create_account.dart';
import '../Client/home_client.dart';
import '../Merchant/home_merchant.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login>{

  static User user;
  String email;
  String pass;
  List<User> users;

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  setEmail(String email){
  this.email = email;
}
  setPassword(String pass){
  this.pass = pass;
}
  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    users = await DBHelper.dbHelper.checkUserInDatabase(email, pass);
    if(users.length > 0){
      user = users[0];
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context){
          if(user.type == 'client'){
            return HomeClient();
          }else if (user.type == 'merchant'){
            return HomeMerchant();
          }
      }));
    }else{
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('error email or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
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
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'password'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'password is empty';
                      }
                    },
                    onSaved: (newValue){
                      setPassword(newValue);
                    },
                  ),
                  SizedBox(height: 100,),
                  // btn login
                  Container(width: 300,color: Colors.blue,child: FlatButton(
                    onPressed: (){
                      saveMyForm();
                      },
                    child: Text('Login',style: TextStyle(color: Colors.white)),),),
                  SizedBox(height: 20,),
                  // go to create account
                  InkWell(child: Center(child: Text("you havent account?? Create Account")),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return CreateAccount();
                        }));
                    },)
                ],
              ),
            )),
        ),
      
    );
  }
}
