import 'package:flutter/material.dart';
import 'add_product.dart';
import 'show_orders.dart';

class HomeMerchant extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeMerchantState();
  }
}

class HomeMerchantState extends State<HomeMerchant> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 200,),
            // btn add product
              Container(width: 300,color: Colors.blue,child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return AddProduct();
                    }));
                },
                child: Text('Add Product',style: TextStyle(color: Colors.white)),)),
              SizedBox(height: 100,),
              // btn my Orders
              Container(width: 300,color: Colors.blue,child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return ShowOrders();
                    }));
                },
                child: Text('My Ordres',style: TextStyle(color: Colors.white)),)),
          ],
        ),
      ),
    );
  }
}
