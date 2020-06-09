import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Classes/Address.dart';
import 'Classes/Order.dart';
import 'Classes/Product.dart';
import 'Classes/User.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

   DBHelper._privateConstructor();
  static final DBHelper dbHelper = DBHelper._privateConstructor();

  static Database _database;
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

  Future<Database> get database async{
    if(_database != null){
      return _database;
    }else{
      _database = await initDB();
      return _database;
    }
  }

  initDB() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path , 'EcommerceDB.db');
    return await openDatabase(path , version: 1 ,onCreate: onCreate);
  }

  Future onCreate(Database db , int version) async{

    await db.execute('''
      CREATE TABLE $userTable(
        $userId INTEGER PRIMARY KEY AUTOINCREMENT ,
        $userName TEXT ,
        $userEmail TEXT ,
        $userPassword TEXT ,
        $userType INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $productTable(
        $productId INTEGER PRIMARY KEY AUTOINCREMENT ,
        $productName TEXT ,
        $productCategory TEXT ,
        $productPrice INTEGER ,
        $productDescription TEXT ,
        $merchantId INTEGER ,
        $productImageBased64 TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $orderTable(
        $orderId INTEGER PRIMARY KEY AUTOINCREMENT ,
        $orderUserId INTEGER ,
        $orderProductId INTEGER ,
        $orderIsAccepted INTEGER ,
        $orderIsConfirmed INTEGER ,
        $orderAddress TEXT
      )
    ''');

      await db.execute('''
      CREATE TABLE $addressTable(
        $addressId INTEGER PRIMARY KEY AUTOINCREMENT ,
        $addressUserId INTEGER ,
        $address TEXT ,
        $city TEXT ,
        $phoneNumber TEXT
      )
    ''');    
    
  }

  insertNewUser(User user) async {
    Database db = await database;
    var result = await db.insert(userTable, user.toMap());
    print(result.toString());
  }

  checkUserInDatabase(String email , String password) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(userTable , 
                                          where: '$userEmail = ? AND $userPassword = ?' , 
                                          whereArgs: [email , password]);
    List<User> users = result.map((item) => User.fromJson(item)).toList();
    return users;
  }

 insertNewProduct(Product product) async {
    Database db = await database;
    var result = await db.insert(productTable, product.toMap());
    print(result.toString());
  }

  getMerchantOrdersToAcceptIt(int oMerchantId) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.rawQuery(
      'SELECT * FROM $orderTable WHERE $orderIsAccepted = 0 AND $orderIsConfirmed = 1 AND $orderProductId IN (SELECT $productId FROM $productTable WHERE $merchantId = $oMerchantId)'
      );
    List<Order> orders = result.map((item) => Order.fromJson(item)).toList();
    return orders;
  }

  getMerchantOrsdersDetailsToDisplayInList(int oMerchantId) async {
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

  getUserDataById(int idUser) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(userTable , 
                                                where: '$userId = ?' , 
                                                whereArgs: [idUser]);
    User user = result.map((item) => User.fromJson(item)).toList()[0];
    return user;
  }

  getProductDataById(int idProduct) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(productTable ,
                                  where: '$productId = ?' ,
                                  whereArgs: [idProduct]);
    Product product = result.map((item) => Product.fromJson(item)).toList()[0];
    return product;
  }

  getCategoryName() async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(productTable , 
                                                        distinct: true ,
                                                        columns: [productCategory]);
    List<dynamic> category = result.map((item) => item[productCategory]).toList();
    return category;
  }

  getProductsWithSpecificCategory(String categoryName) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(productTable , where: '$productCategory = ?' , whereArgs: [categoryName]);
    List<Product> products = result.map((item) => Product.fromJson(item)).toList();
    return products;
  }

  insertNewOrder(Order order) async {
    Database db = await database;
    var result = await db.insert(orderTable, order.toMap());
    print(result.toString());
  }

  getOrderProductToCart(int pUserId) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.rawQuery(
      'SELECT * FROM $productTable WHERE $productId IN (SELECT distinct $orderProductId FROM $orderTable WHERE $orderUserId = $pUserId AND $orderIsAccepted = 0 AND $orderIsConfirmed = 0)'
    );
    List<Product> products = result.map((item) => Product.fromJson(item)).toList();
    return products;
  }

  deleteOrderFromCart(int idProduct , int idUser) async {
    Database db = await database;
    int result = await db.delete(orderTable , where: '$orderUserId = ? AND $orderProductId = ?' , whereArgs: [idUser , idProduct]);
    print(result.toString());
  }

  getUserAdressesFromDatabase(int idUser) async {
      Database db = await database;
      List<Map<String , dynamic>> result = await db.query(addressTable , 
                                          where: '$addressUserId = ?' , 
                                          whereArgs: [idUser]);
      List<Address> addresses = result.map((item) => Address.fromJson(item)).toList();
      return addresses;
  }

  insertNewAddress(Address address) async {
    Database db = await database;
    var result = await db.insert(addressTable, address.toMap());
    print(result.toString());
  }  

  updateOrderAddress(String address , int idUser) async {
    Database db = await database;
    var result = await db.update(orderTable, {orderAddress : address , orderIsConfirmed : 1} , where: '$orderUserId = ? AND $orderIsAccepted = ? AND $orderIsConfirmed =?' , whereArgs: [idUser , 0 , 0]);
    print('update : $result');
  }

  getAddressByUserId(int idUser , int idProduct) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.query(orderTable ,columns: [orderAddress], where: '$orderUserId = ? AND $orderProductId = ? AND $orderIsConfirmed = ? AND $orderIsAccepted = ?' , whereArgs: [idUser , idProduct , 1 , 0]);
    List<dynamic> address = result.map((item) => item[orderAddress]).toList();
    return address;
  }

   updateOrderAccepted(int idUser) async {
    Database db = await database;
    var result = await db.update(orderTable, {orderIsAccepted : 1} , where: '$orderUserId = ? AND $orderIsAccepted = ? AND $orderIsConfirmed =?' , whereArgs: [idUser , 0 , 1]);
    print('update : $result');
  }

  getOrdersToShowToClient(int userId) async {
    Database db = await database;
    List<Map<String , dynamic>> result = await db.rawQuery(
      'SELECT * FROM $orderTable WHERE $orderIsAccepted = 0 AND $orderIsConfirmed = 1 AND $orderUserId = $userId'
      );
    List<Order> orders = result.map((item) => Order.fromJson(item)).toList();
    return orders;
  }

  getClientOrsdersDetailsToDisplayInList(int userId) async {
    List<Product> wholeOrder = [];
    List<Map<String , dynamic>> result;
    Product product;

    Database db = await database;
    List<Order> orders = await getOrdersToShowToClient(userId);

    for(var i = 0 ; i<orders.length ; i++){
          result =  await db.query(productTable , 
                                  where: '$productId = ?' , 
                                  whereArgs: [orders[i].orderProductId]);
          product = result.map((item) => Product.fromJson(item)).toList()[0];
          wholeOrder.add(product);
    }
    return wholeOrder;
  }
}