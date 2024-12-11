import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  String Aname;
  bool isAdmin;
  String Auid;
  String Aemail;
  String Apassword;
  DateTime AlastActive;
  String Aphone;
  String photoUrl;
  Admin({
    this.photoUrl = '',
    this.Aname = '',
    this.isAdmin = false,
    this.Auid = '',
    this.Aemail = '',
    this.Apassword = '',
    required this.AlastActive,
    this.Aphone = '',
  });

  factory Admin.fromMap(Map<String, dynamic> map) {
    // DateTime AlastActive;
    // if (map['createdAT'] is Timestamp) {
    //   AlastActive = (map['AlastActive'] as Timestamp).toDate();
    // } else if (map['AlastActive'] is int) {
    //   AlastActive = DateTime.fromMillisecondsSinceEpoch(map['AlastActive']);
    // } else {
    //   AlastActive = DateTime.now(); // Default value if neither type is matched
    // }
    return Admin(
      Aname: map['Aname'] ?? "",
      isAdmin: map['isAdmin'] as bool,
      Auid: map['Auid'] ?? "",
      Aemail: map['Aemail'] ?? "",
      Apassword: map['Apassword'] ?? "",
      AlastActive: map['AlastActive'] != null
          ? (map['AlastActive'] as Timestamp).toDate()
          : DateTime.now(),
      Aphone: map['Aphone'] ?? "",
      photoUrl: map['photoUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Aname': Aname,
      'isAdmin': isAdmin,
      'Auid': Auid,
      'photoUrl': photoUrl,
      'Aemail': Aemail,
      'Apassword': Apassword,
      'AlastActive': AlastActive,
      'Aphone': Aphone,
    };
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}
