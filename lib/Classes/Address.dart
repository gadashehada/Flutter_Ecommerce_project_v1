import '../DBHelper.dart';

class Address{
  int addressId;
  int addressUserId;
  String address;
  String city;
  String phoneNumber;

  Address({this.addressId , this.addressUserId , this.address , this.city , this.phoneNumber});

  factory Address.fromJson(Map<String , dynamic> json){
    return Address(
      addressId: json[DBHelper.addressId],
      addressUserId: json[DBHelper.addressUserId],
      address: json[DBHelper.address],
      city: json[DBHelper.city],
      phoneNumber: json[DBHelper.phoneNumber]
    );
  }

  Map<String , dynamic> toMap(){
    return {
      DBHelper.addressId : this.addressId ,
      DBHelper.addressUserId : this.addressUserId ,
      DBHelper.address : this.address ,
      DBHelper.city : this.city,
      DBHelper.phoneNumber : this.phoneNumber
    };
  }
}