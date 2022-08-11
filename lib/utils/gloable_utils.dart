import 'package:flutter/material.dart';

Size getSize(context) => MediaQuery.of(context).size;

dp({msg, args}) => debugPrint("\n $msg   $args   \n");

void showToast({context, msg}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 3),
  ));
}

const String MESSAGES_COLLECTION = "messages";
const String USERS_COLLECTION = "users";
const String CONTACTS_COLLECTION = "contacts";

const String TIMESTAMP_FIELD = "timestamp";
const String EMAIL_FIELD = "email";

const String MESSAGE_TYPE_IMAGE = "image";

enum MessageType { Text, Image, Video, File }
