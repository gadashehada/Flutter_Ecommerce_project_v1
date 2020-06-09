import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import '../Auth/login.dart';
import '../DBHelper.dart';
import '../Classes/Product.dart';

class AddProduct extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddProductState();
  }
}

class AddProductState extends State<AddProduct>{

  File _image;
  final picker = ImagePicker();
  String photoBase64;

  String productName;
  int productPrice;
  String productCategory;
  String productDescription;

  GlobalKey<FormState> formKey = GlobalKey();

  setProductName(String productName){
    this.productName = productName;
  }
  setProductPrice(int productPrice){
    this.productPrice = productPrice;
  }
  setProductCategory(String productCategory){
    this.productCategory = productCategory;
  }
  setProductDescription(String productDescription){
    this.productDescription = productDescription;
  }

  Future getImage() async {
    final photo = await picker.getImage(source: ImageSource.gallery);
     _image = await FlutterNativeImage.compressImage(photo.path,
        quality: 100, targetWidth: 120, targetHeight: 120);

    setState(() {
      List<int> imageBytes = _image.readAsBytesSync();
      photoBase64 = base64Encode(imageBytes);
    });
  }
  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
      Product product = Product.fromJson({
      DBHelper.productName: this.productName ,
      DBHelper.productPrice: this.productPrice ,
      DBHelper.productCategory: this.productCategory ,
      DBHelper.productDescription: this.productDescription,
      DBHelper.productImageBased64: this.photoBase64,
      DBHelper.merchantId: LoginState.user.id
    });
    await DBHelper.dbHelper.insertNewProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add product'),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // product name
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Product name'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'name is empty';
                      }
                    },
                    onSaved: (newValue){
                      setProductName(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // product price
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Product price'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'price is empty';
                      }
                    },
                    onSaved: (newValue){
                      setProductPrice(int.parse(newValue));
                    },
                  ),
                  SizedBox(height: 20,),
                  // category name
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Product category'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'category is empty';
                      }
                    },
                    onSaved: (newValue){
                      setProductCategory(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // description
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value){
                      if(value.isEmpty){
                        return 'description is empty';
                      }
                    },
                    onSaved: (newValue){
                      setProductDescription(newValue);
                    },
                  ),
                  SizedBox(height: 20,),
                  // pick image
                  Container(width: 300,color: Colors.blue,child: FlatButton(
                    onPressed: (){getImage();},
                    child: Text('Pick image',style: TextStyle(color: Colors.white)),)),
                  SizedBox(height: 20,),
                  // btn add product
                  Container(width: 300,color: Colors.blue,child: FlatButton(
                    onPressed: (){saveMyForm();},
                    child: Text('Add Product',style: TextStyle(color: Colors.white)),))
                ],
              ),
            )),
        ),
      
    );
  }

}
