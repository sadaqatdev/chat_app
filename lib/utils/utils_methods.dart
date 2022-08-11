import 'dart:io';

import 'package:chat_app/utils/gloable_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UtilsMethods {
  ImagePicker picker = ImagePicker();
  Future<File?> pickImage({required ImageSource source}) async {
    XFile? selectedImage = await picker.pickImage(source: source);
    return selectedImage != null ? File(selectedImage.path) : null;
  }

  Future<File?> pickVideo({required ImageSource source}) async {
    XFile? selectedImage = await picker.pickVideo(source: source);
    return selectedImage != null ? File(selectedImage.path) : null;
  }

  Future<File?> pickeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    return result == null ? null : File(result.files.single.path!);
  }

  static Future<String?> downloadFile(String url) async {
    var responce = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (c, t) {
      dp(msg: "Dowload progress", args: (c / t * 100).toString());
    });
    if (responce.statusCode == 200) {
      try {
        String name =
            url.substring(url.indexOf('%2F') + 3, url.indexOf('?alt'));

        return await FileSaver.instance.saveAs(name.split('.').first,
            responce.data, name.split('.').last, MimeType.OTHER);
      } on Exception catch (e) {
        dp(msg: "Error in writing file", args: e);
        return null;
      }
    } else {
      return null;
    }
  }
}
