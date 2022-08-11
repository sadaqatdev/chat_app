import 'dart:io';

import 'package:chat_app/utils/gloable_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageMethods {
  Future<String> uploadFile(File file) async {
    String fileName = path.basename(file.path);

    Reference storageReference =
        FirebaseStorage.instance.ref().child("documents/$fileName");

    final UploadTask uploadTask = storageReference.putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      dp(
          msg: "Upload percentage",
          args: ((event.bytesTransferred / event.totalBytes) * 100)
              .roundToDouble()
              .toString());
    });

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    final String url = await taskSnapshot.ref.getDownloadURL();

    dp(msg: "Url of files", args: url);

    return url;
  }

  // void uploadImage({
  //   @required File image,
  //   @required String receiverId,
  //   @required String senderId,
  //   @required ImageUploadProvider imageUploadProvider,
  // }) async {
  //   //

  //   final ChatMethods chatMethods = ChatMethods();

  //   // Set some loading value to db and show it to user
  //   imageUploadProvider.setToLoading();

  //   // Get url from the image bucket
  //   String url = await uploadImageToStorage(image);

  //   // Hide loading
  //   imageUploadProvider.setToIdle();

  //   chatMethods.setImageMsg(url, receiverId, senderId);
  // }
}
