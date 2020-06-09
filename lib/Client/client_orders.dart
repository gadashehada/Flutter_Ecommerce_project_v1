import 'dart:convert';
import 'package:flutter/material.dart';
import '../Classes/Product.dart';
import '../Auth/login.dart';
import '../DBHelper.dart';

class ClientOrders extends StatelessWidget {
  
  List<Product> wholeOrder = [];

  getData() async {
    return await DBHelper.dbHelper
      .getClientOrsdersDetailsToDisplayInList(LoginState.user.id);
  }
  getImage(String base64){
      return base64Decode(base64);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.home , color: Colors.white,),
          onPressed: (){
            int count = 0;
            Navigator.popUntil(context, (route){
                if(count++ == 2){
                  return true;
                }else{
                  return false;
                }
            });
          })]),
      body: FutureBuilder(
        future: getData(),
        builder: (context , snapShot){
          if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
            return Container();
          }
          if(snapShot.hasData){wholeOrder = snapShot.data;}
          return Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: wholeOrder.length,
                itemBuilder: (context , index){
                  return Stack(children: <Widget>[
                  // CARD
                  Transform.translate(
                    offset: Offset(24.0, 20.0),
                    child: Container(
                      width: 310.0,
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
                  // TEXT ORDER NAME
                  Transform.translate(
                    offset: Offset(142.0, 40.0),
                    child: Text(
                      'product : ${wholeOrder[index].productName}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // TEXT PRICE
                  Transform.translate(
                    offset: Offset(142.0, 70.0),
                    child: Text(
                      'price : ${wholeOrder[index].productPrice}\$',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // IMAGE
                  Transform.translate(
                    offset: Offset(34.0, 30.0),
                    child:
                        Container(
                      width: 98.0,
                      height: 100.0,
                      child:Image.memory(getImage(wholeOrder[index].imageBased64)) ,
                    ),
                  ),
            ],);
                })
            ],
          );
    
        }));
  }
}
