import 'dart:io';

import 'package:chat_app/utils/gloable_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/message.dart';
import '../models/muser.dart';
import '../utils/utils_methods.dart';
import 'chat_methods.dart';
import 'storage_methods.dart';

class ChatProvider extends ChangeNotifier {
  // all chat realted methods are decleare here and

  ChatMethods methods = ChatMethods();

  UtilsMethods utilsMethods = UtilsMethods();

  StorageMethods storageMethods = StorageMethods();

  bool isWriting = false;

  TextEditingController textFieldController = TextEditingController();

  FocusNode textFieldFocus = FocusNode();

  late MUser sender;

  String? _currentUserId;

  bool isUploading = false;

  initUser() {
    methods.getCurrentUser().then((user) {
      _currentUserId = user?.uid;

      sender = MUser(
        uid: user?.uid,
        name: user?.displayName,
        profilePhoto: user?.photoURL,
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  // the following method send files base on [MessageType], type
  //

  Future sendFile(
      {ImageSource? source,
      required String receverId,
      required MessageType type,
      context}) async {
    File? selectedImage;

    if (type == MessageType.Image) {
      var r = await Permission.photos.request();
      if (r.isGranted) {
        //pick image from give source either gallery or camera and following method return File object
        selectedImage = await utilsMethods.pickImage(source: source!);
        //close bottom sheet
        Navigator.maybePop(context);
      } else {
        showToast(context: context, msg: "Permission not Granted");
      }
    } else if (type == MessageType.Video) {
      var r = await Permission.photos.request();
      if (r.isGranted) {
        //pick video from gallery or given source and following method return File object
        selectedImage = await utilsMethods.pickVideo(source: source!);
        //close bottom sheet
        Navigator.maybePop(context);
      } else {
        showToast(context: context, msg: "Permission not Granted");
      }
    } else {
      var r = await Permission.storage.request();
      if (r.isGranted) {
        //pick file from file explorer of mobile device and following method return File object
        selectedImage = await utilsMethods.pickeFile();
        //close bottom sheet
        Navigator.maybePop(context);
      } else {
        showToast(context: context, msg: "Permission not Granted");
      }
    }

    if (selectedImage != null) {
      isUploading = true;
      notifyListeners();
      String url = await storageMethods.uploadFile(selectedImage);

      Message message = Message(
          message: url,
          receiverId: receverId,
          senderId: _currentUserId,
          timestamp: Timestamp.now(),
          type: type.index);

      methods.addMessageToDb(message);
      isUploading = false;
      notifyListeners();
    }
  }

  // send text message to recevier
  Future sendTextMessageMessage(
      {required String text, required String recevierId}) async {
    //

    Message message = Message(
      receiverId: recevierId,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: MessageType.Text.index,
    );

    setWritingTo(false);

    await methods.addMessageToDb(message);
  }

  setWritingTo(bool isWrite) {
    //
    isWriting = isWrite;
    notifyListeners();
  }

  //
}
