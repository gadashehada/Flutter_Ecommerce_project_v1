import '../DBHelper.dart';

class Order{
  int orderId;
  int orderUserId;
  int orderProductId;
  String orderAddress;
  bool isAccept;
  bool isConfirmed;

    Order({this.orderId , this.orderUserId , this.orderProductId ,this.orderAddress , this.isAccept , this.isConfirmed});

  factory Order.fromJson(Map<String , dynamic> json){
    return Order(
      orderId: json[DBHelper.orderId],
      orderUserId: json[DBHelper.orderUserId],
      orderProductId: json[DBHelper.orderProductId],
      orderAddress: json[DBHelper.orderAddress],
      isAccept: json[DBHelper.orderIsAccepted] == 0? false:true ,
      isConfirmed: json[DBHelper.orderIsConfirmed] == 0? false:true
      );
  }

  Map<String , dynamic> toMap(){
    return {
      DBHelper.orderUserId : this.orderUserId ,
      DBHelper.orderProductId : this.orderProductId ,
      DBHelper.orderIsAccepted : this.isAccept? 1:0 ,
      DBHelper.orderIsConfirmed : this.isConfirmed? 1:0 ,
      DBHelper.orderAddress : ''
    };
  }
}