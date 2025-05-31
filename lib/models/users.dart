import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String fullName, email, phone, uid, gender;
  final Timestamp createdAt;

  Users(this.fullName, this.email, this.phone, this.uid,this.gender, this.createdAt);
  factory Users.fromJson(json) {
    return Users(
      json['name']??'',
      json['email'],
      json['phone'] ?? '',
      json['uid'],
      json['gender'] ,
      json['createdAt'] ?? Timestamp.now(),
    );
  }
}
