import 'package:flutter/material.dart';
import 'package:project_ecommerce_v2/DBHelper.dart';

class OrderDetails extends StatefulWidget{

  String productList;
  String clientName;
  String idProduct;
  String idUser;

  String address = '';

  OrderDetails({this.productList , this.clientName , this.idUser , this.idProduct});

  getAddress() async {
    return await DBHelper.dbHelper.getAddressByUserId(this.idUser, this.idProduct);
  }

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsState();
  }
}

class OrderDetailsState extends State<OrderDetails> {

  updateData() async {
     await DBHelper.dbHelper.updateOrderAccepted(widget.idUser);

     Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details"),),
      body: FutureBuilder(
        future: widget.getAddress(),
        builder: (context , snapShot){
        if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
          return Container();
        }
        if(snapShot.hasData){widget.address = snapShot.data[0]; }
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  // client name
                  Transform.translate(
                    offset: Offset(24.0, 20.0),
                    child: Text(
                      'Client name',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff8d8686),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(24.0, 40.0),
                    child: Text(
                      widget.clientName,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 18,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // address name
                  Transform.translate(
                    offset: Offset(24.0, 80.0),
                    child: Text(
                      'Adress Name',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff8d8686),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(24.0, 100.0),
                    child: Text(
                      widget.address,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 18,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // product list
                  Transform.translate(
                    offset: Offset(24.0, 140.0),
                    child: Text(
                      'Product List',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xff8d8686),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(24.0, 160.0),
                    child: Text(
                      widget.productList,
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 18,
                        color: const Color(0xff0f0e0e),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(24.0, 480.0),
                    child: Container(width: 300,color: Colors.blue,child: FlatButton(child: Text(''),onPressed: (){},)),
                  ),
                ],
              ),
              SizedBox(height: 415,),
              // btn accept
              FlatButton(
                onPressed: (){
                  updateData();
                }, 
                child: Text('Accept',style: TextStyle(color: Colors.white)))
            ],
          );
      })
    );
  }
}