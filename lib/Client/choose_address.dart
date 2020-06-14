import 'package:flutter/material.dart';
import 'package:project_ecommerce_v2/DBHelper.dart';
import 'create_address.dart';
import '../Auth/login.dart';
import '../Classes/Address.dart';
import 'client_orders.dart';

class ChooseAddress extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChooseAddressState();
  }
}

class ChooseAddressState extends State<ChooseAddress> {

  confirmOrder() async {
    await DBHelper.dbHelper.updateOrderAddress(AddressItemState.valueGroup, LoginState.user.id);
    Navigator.pushReplacement(context , MaterialPageRoute(
    builder: (context){
      return ClientOrders();
    }));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("choose address"),),
      body: Stack(
        children: <Widget>[
          AddressItem(),
          // btn add address
          Transform.translate(
            offset: Offset(24.0, 410.0),
            child: Container(width: 300,color: Colors.blue,child: FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return CraeteAddress();
                    }));
                  },
                  child: Text('Add Adress',style: TextStyle(color: Colors.white)),),
          ),),
          // btn confirm order  
          Transform.translate(
            offset: Offset(24.0, 473.0),
            child: Container(width: 300,color: Colors.blue,child: FlatButton(
                  onPressed: (){
                    confirmOrder();
                  },
                  child: Text('Confirm',style: TextStyle(color: Colors.white)),),
          ),)
        ],
      )
    );
  }
}

class AddressItem extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddressItemState();
  }
}

class AddressItemState extends State<AddressItem>{

  int _currentIndex = 0;
  static String valueGroup;
  List<Address> addresses;
  List<String> _texts = [];

  getAdresses() async {
    return await DBHelper.dbHelper.getUserAdressesFromDatabase(LoginState.user.id);
  } 

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAdresses(),
        builder: (context , snapShot){
          if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
            return Container();
          }
          addresses = snapShot.data;
          _texts = [];
          for(int i = 0; i< addresses.length ; i++){_texts.add('${addresses[i].city} - ${addresses[i].address}');}
          valueGroup = _texts.length > 0 ? _texts[_currentIndex]: '';
          
          return ListView(
            padding: EdgeInsets.all(8.0),
            children: _texts.map((text) => RadioListTile(
              groupValue: valueGroup,
              title: Text("$text"),
              value: text,
              onChanged: (val) {
                setState(() {
                _currentIndex = _texts.indexOf(val);
                });
              },
            )).toList(),
          );
        }
    );
  }
}