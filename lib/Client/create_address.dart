import 'package:flutter/material.dart';
import '../Classes/Address.dart';
import '../Auth/login.dart';
import '../DBHelper.dart';

class CraeteAddress extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CraeteAddressState();
  }
}

class CraeteAddressState extends State<CraeteAddress>{

  String name;
  String address;
  String city;
  String phoneNumber;

  GlobalKey<FormState> formKey = GlobalKey();

  setName(String name){
    this.name = name;
  }
  setAddress(String address){
    this.address = address;
  }
  setCity(String city){
    this.city = city;
  }
  setPhoneNumber(String phoneNumber){
    this.phoneNumber = phoneNumber;
  }

  saveMyForm() async{
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
      Address address = Address.fromJson({
      DBHelper.addressUserId: LoginState.user.id ,
      DBHelper.address: this.address ,
      DBHelper.city: this.city ,
      DBHelper.phoneNumber: this.phoneNumber
    });
    await DBHelper.dbHelper.insertNewAddress(address);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Address'),
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
                  // address
                  TextFormField(
                    decoration: InputDecoration(labelText: 'address'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'address is empty';
                      }
                    },
                    onSaved: (newValue){
                      setAddress(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // city
                  TextFormField(
                    decoration: InputDecoration(labelText: 'city'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'city is empty';
                      }
                    },
                    onSaved: (newValue){
                      setCity(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // phone number
                  TextFormField(
                    decoration: InputDecoration(labelText: 'phone number'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'phone number is empty';
                      }
                    },
                    onSaved: (newValue){
                      setPhoneNumber(newValue);
                    },
                  ),
                  SizedBox(height: 50,),
                  // btn create address
                  Container(width: 300,color: Colors.blue,child: FlatButton(
                    onPressed: (){saveMyForm();},
                    child: Text('Create Address',style: TextStyle(color: Colors.white)),)
                  ),
                ],
              ),
            )),
      ), 
    );
  }
}
