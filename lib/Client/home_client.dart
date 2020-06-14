import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce_v2/Auth/login.dart';
import 'package:project_ecommerce_v2/DBHelper.dart';
import '../Classes/Product.dart';
import 'product_details.dart';
import 'client_cart.dart';

class HomeClient extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeClientState();
  }
}

class HomeClientState extends State<HomeClient> {

  static String categoryName = 'fashion';
  List<dynamic> categories;

  getCategoryName() async {
    return await DBHelper.dbHelper.getCategoryName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart , color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context){
                return ClientCart();
                }
              ));
            }) ,
          IconButton(
          icon: Icon(Icons.exit_to_app , color: Colors.white,),
          onPressed: (){
            LoginState.user = null;
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context){
                return Login();
                }
              ));
          })]),
      body: Stack(
        children: <Widget>[
          // text categories
          Transform.translate(
            offset: Offset(24.0, 20.0),
            child: Text(
              'categories',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xff0f0e0e),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // get Categories
          FutureBuilder(
              future: getCategoryName(),
              builder: (context , snapShot){
                if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
                  return Container();
                }
                if(snapShot.hasData){categories = snapShot.data;}
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context , index){
                      return Stack(children: <Widget>[
                      // card categories item
                          Transform.translate(
                            offset: Offset(24.0, 60.0),
                            child: Container(
                              width: 97.0,
                              height: 58.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue,
                                    offset: Offset(0, 3),
                                    blurRadius: 6)
                                ],
                              ),
                              child: FlatButton(onPressed: (){
                                setState(() {
                                  HomeClientState.categoryName = categories[index];
                                });
                              }, child: Text(categories[index] , style: TextStyle(color: Colors.white))),
                            ),
                          ),
                      ],);
                    });
            }),          
          // text products
          Transform.translate(
            offset: Offset(24.0, 160.0),
            child: Text(
              'Products',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xff0f0e0e),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(8.0, 200.0),
            child: ProductsItem(categoryName),
            )       
        ],
      ),
    );
  }
}

class ProductsItem extends StatefulWidget{
  
  ProductsItem(String categoryName){
    HomeClientState.categoryName = categoryName;
  }

  @override
  State<StatefulWidget> createState() {
    return ProductsItemState();
  }
}

class ProductsItemState extends State<ProductsItem>{
    
  List<Product> products;

  void initState(){
    Firestore.instance.collection('products').snapshots().listen((querySnapshot){
      products = querySnapshot.documentChanges.map((item) => Product.fromJson(item.document.data)).toList();
      setState(() {});
    });
    DBHelper.dbHelper.listenToChangesIsAccepted(LoginState.user.id);
    super.initState();
  }

  getProducts() async {
      return await DBHelper.dbHelper.getProductsWithSpecificCategory(HomeClientState.categoryName);
    }
  getImage(String base64){
      return base64Decode(base64);
    }
    
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProducts(),
      builder: (context , snapShot){
        if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
          return Container();
        }
        products = snapShot.data;
        return GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context , index){
            return Stack(children: <Widget>[
              // product images
              Transform.translate(
                offset: Offset(24.0, 0.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return ProductDetails(product:products[index]);
                      }));
                  },
                  child: Container(
                    width: 113.0,
                    height: 100.0,
                    child: Image.memory(getImage(products[index].imageBased64)),
                  ),
                )
              ),
              // card product text
              Transform.translate(
                offset: Offset(24.0, 100.0),
                child: Container(
                  width: 113.0,
                  height: 55.0,
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
              // product name
              Transform.translate(
                offset: Offset(31.0, 105.0),
                child: Text(
                  products[index].productName ,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 16,
                    color: const Color(0xff0f0e0e),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // product price
              Transform.translate(
                offset: Offset(31.0, 130.0),
                child: Text(
                  products[index].productPrice.toString(),
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 16,
                    color: const Color(0xff0f0e0e),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ]);
          }) ;
      });
  }
}