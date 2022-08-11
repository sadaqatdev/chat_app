import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId;
  String? receiverId;
  int? type;
  String? message;
  Timestamp? timestamp;

  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  Message.imageMessage({
    this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  Map toImageMap() {
    var map = <String, dynamic>{};
    map['message'] = message;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['timestamp'] = timestamp;

    return map;
  }

  // named constructor
  Message.fromMap(Map<String, dynamic> map) {
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    type = map['type'];
    message = map['message'];
    timestamp = map['timestamp'];
  }
}
