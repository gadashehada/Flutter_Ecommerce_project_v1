import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_ecommerce_v2/Classes/User.dart';
import 'package:project_ecommerce_v2/notifaction.dart';
import 'package:uuid/uuid.dart';
import 'Classes/Address.dart';
import 'Classes/Order.dart';
import 'Classes/Product.dart';
import 'Classes/User.dart';

class DBHelper{

   DBHelper._privateConstructor();
  static final DBHelper dbHelper = DBHelper._privateConstructor();

  String userTable = 'users';
  static String userId = 'user_id';
  static String userName = 'user_name';
  static String userEmail = 'user_email';
  static String userPassword = 'user_password';
  static String userType = 'user_type';

  String productTable = 'products';
  static String productId = 'product_id';
  static String productName = 'user_name';
  static String productCategory = 'product_category';
  static String productPrice = 'product_price';
  static String productDescription = 'product_description';
  static String productImageBased64 = 'product_image_based64';
  static String merchantId = 'merchant_id';

  String orderTable = 'orders';
  static String orderId = 'order_id';
  static String orderUserId = 'order_user_id';
  static String orderProductId = 'order_product_id';
  static String orderIsAccepted = 'isAccepted';
  static String orderIsConfirmed = 'isConfirmed';
  static String orderAddress = 'order_address';

  String addressTable = 'addresses';
  static String addressId = 'address_id';
  static String addressUserId = 'address_user_id';
  static String address = 'address';
  static String city = 'city';
  static String phoneNumber = 'phone_number';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  insertNewUser(User user) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    
    if(authResult != null){
      await _firestore.collection(userTable).document().setData(user.toMap(authResult.user.uid));
    }
  }

  checkUserInDatabase(String email , String password) async {
    List<User> users = [];
    AuthResult authRestult = await _auth.signInWithEmailAndPassword(
            email: email, password: password).catchError((error){print(error.toString());});

    if(authRestult != null){
     await _firestore.collection(userTable)
                  .where(userId, isEqualTo: authRestult.user.uid)
                  .getDocuments().then((querySnapshot){
                    users = querySnapshot.documents.map((item) => User.fromJson(item.data)).toList();
                  });
    }
    return users;
  }

  insertNewProduct(Product product) async {
    product.productId = Uuid().v4();
    var result = await _firestore.collection(productTable).add(product.toMap());
    if(result != null){
      return true;
    }else{
      return false;
    }
  }

  getMerchantOrdersToAcceptIt(String oMerchantId) async {
    List<String> productsId = [];
    List<Order> orders = [];
    await _firestore.collection(productTable)
                    .where(merchantId , isEqualTo: oMerchantId)
                    .getDocuments().then((querySnapshot){
                      querySnapshot.documents.forEach((item) => productsId.add(item.data[productId]));
                    });
    await _firestore.collection(orderTable)
                  .where(orderProductId, whereIn: productsId)
                  .where(orderIsAccepted , isEqualTo: 0)
                  .where(orderIsConfirmed , isEqualTo: 1)
                  .getDocuments().then((querySnapshot){
                    orders = querySnapshot.documents.map((item) => Order.fromJson(item.data)).toList();
                  });
    return orders;
  }

  getMerchantOrsdersDetailsToDisplayInList(String oMerchantId) async {
    List<Map<User , Product>> wholeOrder = [];
    User user;
    Product product;
    List<Order> orders = await getMerchantOrdersToAcceptIt(oMerchantId);

    for(var i = 0 ; i<orders.length ; i++){
      user = await getUserDataById(orders[i].orderUserId);
      product = await getProductDataById(orders[i].orderProductId);
      wholeOrder.add({user:product});
    }
    return wholeOrder;
  }

  getUserDataById(String idUser) async {
    User user;
    await _firestore.collection(userTable)
                  .where(userId, isEqualTo: idUser)
                  .getDocuments().then((querySnapshot){
                    user = querySnapshot.documents.map((item) => User.fromJson(item.data)).toList()[0];
                  });
    return user;
  }

  getProductDataById(String idProduct) async {
    Product product;
    await _firestore.collection(productTable)
                  .where(productId, isEqualTo: idProduct)
                  .getDocuments().then((querySnapshot){
                    product = querySnapshot.documents.map((item) => Product.fromJson(item.data)).toList()[0];
                  });
    return product;
  }

  getCategoryName() async {
    List<dynamic> categories = [];
    await _firestore.collection(productTable)
                  .getDocuments().then((querySnapshot){
                    categories = querySnapshot.documents.map((item) => item.data[productCategory]).toList();
                  });
    Set mSet = Set<String>.from(categories.map((category) => category));
    List<dynamic> distinctList = mSet.map((category) => category).toList();

    return distinctList;
  }

  getProductsWithSpecificCategory(String categoryName) async {
    List<Product> products = [];
    await _firestore.collection(productTable)
                    .where(productCategory , isEqualTo: categoryName)
                    .getDocuments().then((querySnapshot){
                      products = querySnapshot.documents.map((item) => Product.fromJson(item.data)).toList();
                    });
    return products;
  }

  insertNewOrder(Order order) async {
    order.orderId = Uuid().v4();
    await _firestore.collection(orderTable).add(order.toMap());
  }

  getOrderProductToCart(String pUserId) async {
    List<String> productsId = [];
    List<Product> products = [];
    await _firestore.collection(orderTable)
                    .where(orderUserId , isEqualTo: pUserId)
                    .where(orderIsAccepted , isEqualTo: 0)
                    .where(orderIsConfirmed , isEqualTo: 0)
                    .getDocuments().then((querySnapshot){
                      querySnapshot.documents.forEach((item) => productsId.add(item.data[orderProductId]));
                    });
    await _firestore.collection(productTable)
                  .where(productId, whereIn: productsId)
                  .getDocuments().then((querySnapshot){
                    products = querySnapshot.documents.map((item) => Product.fromJson(item.data)).toList();
                  });
    return products;
  }

  deleteOrderFromCart(String idProduct , String idUser) async {
    String documentId = '';
    await _firestore.collection(orderTable)
                .where(orderUserId , isEqualTo: idUser)
                .where(orderProductId , isEqualTo: idProduct)
                .where(orderIsConfirmed , isEqualTo: 0)
                .where(orderIsAccepted , isEqualTo: 0)
                .getDocuments().then((snapShot){
                  documentId = snapShot.documents.first.documentID;
                });
    await _firestore.collection(orderTable).document(documentId).delete();
  }

  getUserAdressesFromDatabase(String idUser) async {
    List<Address> addresses = [];
    await _firestore.collection(addressTable)
                  .where(addressUserId, isEqualTo: idUser)
                  .getDocuments().then((querySnapshot){
                    addresses = querySnapshot.documents.map((item) => Address.fromJson(item.data)).toList();
                  });
    return addresses;
  }

  insertNewAddress(Address address) async {
    address.addressId = Uuid().v4();
    var result = await _firestore.collection(addressTable).add(address.toMap());
  }  

  updateOrderAddress(String address , String idUser) async {
    List<String> documentsId = [];
    await _firestore.collection(orderTable)
                .where(orderUserId , isEqualTo: idUser)
                .where(orderIsConfirmed , isEqualTo: 0)
                .where(orderIsAccepted , isEqualTo: 0)
                .getDocuments().then((snapShot){
                  snapShot.documents.forEach((item){
                      documentsId.add(item.documentID);
                  });
                  // documentId = snapShot.documents.first.documentID;
                });
    documentsId.forEach((id) async {
      await _firestore.collection(orderTable).document(id)
                      .updateData({orderAddress : address , orderIsConfirmed : 1});
    });
    
  }

  getAddressByUserId(String idUser , String idProduct) async {
    List<dynamic> addresses = [];
    await _firestore.collection(orderTable)
                  .where(orderUserId, isEqualTo: idUser)
                  .where(orderProductId, isEqualTo: idProduct)
                  .where(orderIsConfirmed, isEqualTo: 1)
                  .where(orderIsAccepted, isEqualTo: 0)
                  .getDocuments().then((querySnapshot){
                    addresses = querySnapshot.documents.map((item) => item.data[orderAddress]).toList();
                  });
    return addresses;
  }

  updateOrderAccepted(String idUser) async {
    List<String> documentsId = [];
    await _firestore.collection(orderTable)
                .where(orderUserId , isEqualTo: idUser)
                .where(orderIsConfirmed , isEqualTo: 1)
                .where(orderIsAccepted , isEqualTo: 0)
                .getDocuments().then((snapShot){
                  snapShot.documents.forEach((item){
                    documentsId.add(item.documentID);
                  });
                });
    documentsId.forEach((id) async {
      await _firestore.collection(orderTable).document(id)
                      .updateData({orderIsAccepted : 1});
    });
    
  }

  getOrdersToShowToClient(String userId) async {
    List<Order> orders = [];
    await _firestore.collection(orderTable)
                  .where(orderUserId, isEqualTo: userId)
                  .where(orderIsConfirmed, isEqualTo: 1)
                  .where(orderIsAccepted, isEqualTo: 0)
                  .getDocuments().then((querySnapshot){
                    orders = querySnapshot.documents.map((item) => Order.fromJson(item.data)).toList();
                  });
    return orders;
  }

  getClientOrsdersDetailsToDisplayInList(String userId) async {
    List<Product> wholeOrder = [];
    List<Map<String , dynamic>> result;
    Product product;

    List<Order> orders = await getOrdersToShowToClient(userId);

    for(var i = 0 ; i<orders.length ; i++){
          await _firestore.collection(productTable)
                  .where(productId, isEqualTo: orders[i].orderProductId)
                  .getDocuments().then((querySnapshot){
                    product = querySnapshot.documents.map((item) => Product.fromJson(item.data)).toList()[0];
                  });
          wholeOrder.add(product);
    }
    return wholeOrder;
  }

  listenToChangesIsAccepted(String idUser) async {
    _firestore.collection(orderTable).snapshots().listen((querySnapshot){
      querySnapshot.documentChanges.forEach((item) async {
        if(item.document.data[orderUserId] == idUser 
        && item.document.data[orderIsAccepted] == 1
        && item.document.data[orderIsConfirmed] == 1){
          Notifaction not = new Notifaction();
          await not.showNotification('your order is accepted');
          return;
        }
      });
    });
  }

  listenToChangesIsConfirmed(String idMerchant) async {
    _firestore.collection(orderTable).snapshots().listen((querySnapshot){
      querySnapshot.documentChanges.forEach((item) async {
        await _firestore.collection(productTable)
                          .where(productId , isEqualTo: item.document.data[orderProductId])
                          .getDocuments().then((data){
                            if(data.documents.first.data[merchantId] == idMerchant
                                && item.document.data[orderIsConfirmed] == 1
                                && item.document.data[orderIsAccepted] == 0
                            ){
                                Notifaction not = new Notifaction();
                                not.showNotification('you have an order');
                                return;
                            }
                          });
      });
    });
  }
}