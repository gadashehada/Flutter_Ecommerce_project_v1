import 'package:project_ecommerce_v2/DBHelper.dart';

class Product{
  String productName;
  int productPrice;
  String productCategory;
  String productDescription;
  String imageBased64;
  String productId;
  String merchantId;

  Product({this.productName , this.productPrice , this.productCategory , this.productDescription , this.imageBased64 , this.productId , this.merchantId});

  factory Product.fromJson(Map<String , dynamic> json){
    return Product(
      productName: json[DBHelper.productName],
      productPrice: json[DBHelper.productPrice],
      productCategory: json[DBHelper.productCategory],
      productDescription: json[DBHelper.productDescription],
      imageBased64: json[DBHelper.productImageBased64],
      productId: json[DBHelper.productId],
      merchantId: json[DBHelper.merchantId]);
  }

  Map<String , dynamic> toMap(){
    return {
      DBHelper.productId : this.productId ,
      DBHelper.productName : this.productName ,
      DBHelper.productPrice : this.productPrice ,
      DBHelper.productCategory : this.productCategory ,
      DBHelper.productDescription : this.productDescription,
      DBHelper.productImageBased64 : this.imageBased64,
      DBHelper.merchantId : this.merchantId
    };
  }
}