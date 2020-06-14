import 'dart:convert';
import 'package:flutter/material.dart';
import '../Classes/Order.dart';
import '../Classes/Product.dart';
import 'client_cart.dart';
import '../Auth/login.dart';
import '../DBHelper.dart';

class ProductDetails extends StatefulWidget{

  Product product;
  ProductDetails({this.product});

  @override
  State<StatefulWidget> createState() {
    return ProductDetailsState();
  }

}

class ProductDetailsState extends State<ProductDetails> {
 
  getImage(String base64){
      return base64Decode(base64);
  }

  addProductToCart(String productId) async {
    Order order = Order.fromJson({
    DBHelper.orderProductId: productId ,
    DBHelper.orderUserId: LoginState.user.id ,
    DBHelper.orderIsAccepted: 0 ,
    DBHelper.orderIsConfirmed: 0
    });
  await DBHelper.dbHelper.insertNewOrder(order);

  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context){
      return ClientCart();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details"),),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // price
              Transform.translate(
                offset: Offset(18.0, 200.0),
                child: Text(
                  widget.product.productPrice.toString(),
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: const Color(0xff0f0e0e),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // description
              Transform.translate(
                offset: Offset(18.0, 260.0),
                child: Text(
                  widget.product.productDescription,
                  maxLines: 5,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: const Color(0xff0f0e0e),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // image
              Transform.translate(
                offset: Offset(11.0, 0.0),
                child:  Container(
                  width: 340.0,
                  height: 132.0,
                  child: Image.memory(getImage(widget.product.imageBased64) , scale: 0.8, fit: BoxFit.fitWidth,),
                ),
              ),
              // product name
              Transform.translate(
                offset: Offset(18.0, 170.0),
                child: Text(
                  widget.product.productName,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 24,
                    color: const Color(0xff0c50aa),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          SizedBox(height: 350,),
          // btn buy now
          Container(width: 300,color: Colors.blue,child: FlatButton(
            onPressed: (){
              addProductToCart(widget.product.productId);
            },
            child: Text('Buy Now',style: TextStyle(color: Colors.white)),)),
        ],
      ),
    );
  }
}