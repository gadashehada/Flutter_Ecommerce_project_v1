import 'package:flutter/material.dart';
import 'package:project_ecommerce_v2/DBHelper.dart';
import '../Classes/Product.dart';
import '../Classes/User.dart';
import '../Auth/login.dart';
import 'order_details.dart';

class ShowOrders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ShowOrdersState();
  }
}

class ShowOrdersState extends State<ShowOrders> {
  
  List<Map<User , Product>> wholeOrder = [];
  int index;

  getData() async {
    return await DBHelper.dbHelper
      .getMerchantOrsdersDetailsToDisplayInList(LoginState.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
        builder: (context , snapShot){
          if(snapShot.connectionState == ConnectionState.none && snapShot.hasData == null){
            return Container();
          }
          if(snapShot.hasData){wholeOrder = snapShot.data;}
          return Scaffold(
            appBar: AppBar(title : Text("Orders")),
            body: Stack(
              children: <Widget>[
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: wholeOrder.length,
                  itemBuilder: (context , index){
                    return Stack(children: <Widget>[
                      // card
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
                      // text client name
                      Transform.translate(
                          offset: Offset(40.0, 40.0),
                          child: Text( 
                            '${wholeOrder[index].keys.first.name}',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xff0f0e0e),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      // price
                      Transform.translate(
                          offset: Offset(40.0, 70.0),
                          child: Text(
                            '${wholeOrder[index].values.first.productName}',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xff0f0e0e),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      // text order name
                      Transform.translate(
                          offset: Offset(40.0, 100.0),
                          child: Text(
                            '${wholeOrder[index].values.first.productPrice}\$',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xff0f0e0e),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      // button details
                      Transform.translate(
                          offset: Offset(240.0, 90.0),
                          child: InkWell(
                            onTap: (){
                              String productList = '';
                              for(int i = 0 ; i<wholeOrder.length ; i++){
                                if(wholeOrder[i].keys.first.id == wholeOrder[index].keys.first.id){
                                  productList += '${wholeOrder[i].values.first.productName}\n';
                                }
                              }
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return OrderDetails(
                                    productList: productList, 
                                    clientName : wholeOrder[index].keys.first.name,
                                    idProduct : wholeOrder[index].values.first.productId,
                                    idUser : wholeOrder[index].keys.first.id);
                              }));
                              },
                            child: Container(
                              width: 77.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.blue,
                                border: Border.all(width: 1.0, color: Colors.blue),
                                
                              ),
                              child: Center(child: Text('Details',style: TextStyle(color: Colors.white)))
                            ),
                          ),
                        ),
                    ],);
                  })
                ],
              ),
            );
        });
  }
}