import 'package:chat_app/utils/gloable_utils.dart';
import 'package:chat_app/utils/utils_methods.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import '../models/message.dart';

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;
  // '/storage/emulated/0/Documents/ChatAppDoc
  @override
  Widget build(BuildContext context) {
    dp(msg: "Path", args: message.message);
    dp(
        msg: "Path",
        args: message.message?.substring(message.message!.indexOf('%2F') + 3,
            message.message!.indexOf('?alt')));
    var l = message.message?.substring(
        message.message!.indexOf('%2F') + 3, message.message!.indexOf('?alt'));
    dp(msg: "Path", args: l!.split('.').last);
    return Row(
      children: [
        InkWell(
            onTap: () async {
              await downloadFile(context);
            },
            child: const Icon(Icons.file_download)),
        const SizedBox(
          width: 12,
        ),
        const Text("Files"),
      ],
    );
  }

  Future<void> downloadFile(context) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var localPath = await UtilsMethods.downloadFile(message.message!);
      //await OpenFile.open(localPath);
    } else {
      showToast(context: context, msg: "Permission not granted");
    }
  }
}
