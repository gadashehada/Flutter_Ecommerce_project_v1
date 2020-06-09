import 'dart:convert';
import 'package:flutter/material.dart';
import '../Classes/Product.dart';
import 'choose_address.dart';
import '../Auth/login.dart';
import '../DBHelper.dart';

class ClientCart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ClientCartState();
  }
}

class ClientCartState extends State<ClientCart> {

  List<Product> products = [];
  List<int> counts = [];

  getProducts() async {
      return await DBHelper.dbHelper.getOrderProductToCart(LoginState.user.id);
  }
  getImage(String base64){
      return base64Decode(base64);
  } 
  deleteOrderSelected(int idProduct) async {
    await DBHelper.dbHelper.deleteOrderFromCart(idProduct, LoginState.user.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(  
      appBar: AppBar(title: Text("Cart"),),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context , snapShot){
        if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
          return Container();
        }
        if(snapShot.hasData){ products = snapShot.data; }
        for(int i = 0 ; i< products.length ; i++){counts.add(1);}

        return Stack(
          children: <Widget>[
            ListView.builder( 
              itemCount: products.length,
              itemBuilder: (context , index){
                return Stack(children: <Widget>[
                  // card
                  Transform.translate(
                    offset: Offset(24.0, 20.0),
                    child: Container(
                      width: 310.00,
                      height: 125.0,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                        ],
                      ),
                    ),
                  ),
                  // text order name
                  Transform.translate(
                    offset: Offset(142.0, 35.0),
                    child: Text(
                      products[index].productName,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // text price
                  Transform.translate(
                    offset: Offset(142.0, 60.0),
                    child: Text(
                      products[index].productPrice.toString(),
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // image
                  Transform.translate(
                    offset: Offset(34.0, 30.0),
                    child:  Container(
                      width: 98.0,
                      height: 100.0,
                      child: Image.memory(getImage(products[index].imageBased64)),
                    ),
                  ),
                  //border number
                  Transform.translate(
                    offset: Offset(174.0, 100.0),
                    child: Container(
                      width: 30.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                    ),
                  ),
                  // number
                  Transform.translate(
                    offset: Offset(185.5, 103.0),
                    child: Text(
                      counts[index].toString(),
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // border plus
                  Transform.translate(
                    offset: Offset(151.0, 100.0),
                    child: Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                    ),
                  ),
                  // plus icon
                  Transform.translate(
                    offset: Offset(138.0, 87.0),
                    child:IconButton(
                      icon: Icon(Icons.add), 
                      onPressed: (){counts[index]++; setState(() {});})
              
                  ),
                  // mins button
                  Transform.translate(
                    offset: Offset(205.0, 100.0),
                    child:  Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(192.0, 87.0),
                    child:IconButton(
                      icon: Icon(Icons.remove), 
                      onPressed: (){if(counts[index] > 0){counts[index]--; setState(() {}); }})
                  ),
                  // delete button
                  Transform.translate(
                    offset: Offset(290.0, 15.0),
                    child:IconButton(
                      icon: Icon(Icons.close), 
                      onPressed: (){deleteOrderSelected(products[index].productId);})
                  ),
                ],);
            }),
            // btn continue
            Transform.translate(
              offset: Offset(24.0, 480.0),
              child:  Container(width: 300,color: Colors.blue,child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return ChooseAddress();
                    }));
                },
                child: Text('Countinue',style: TextStyle(color: Colors.white)),)
              )),
          ],
        );
        }),
    );
  }
}
