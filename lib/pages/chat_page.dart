import 'package:chat_app/controllers/chat_methods.dart';
import 'package:chat_app/controllers/chat_provider.dart';
import 'package:chat_app/pages/video_player_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../models/muser.dart';
import '../utils/gloable_utils.dart';
import '../widgets/cashed_image.dart';
import '../widgets/document_widget.dart';

class ChatPage extends StatefulWidget {
  final MUser receiver;
  static String chatPageRoute = 'ChatPage';
  const ChatPage({Key? key, required this.receiver}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FocusNode textFieldFocus = FocusNode();

  final currenUserId = FirebaseAuth.instance.currentUser!.uid;

  ChatMethods chatMethods = ChatMethods();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // initalized current user value
    chatProvider.initUser();
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  @override
  Widget build(BuildContext context) {
    dp(
      msg: "rebuild",
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver.name ?? "")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
              stream: chatMethods.getMessages(widget.receiver.uid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  reverse: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return chatMessageItem(snapshot.data!.docs[index]);
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(builder: (context, chatProvider, w) {
            return chatProvider.isUploading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : chatControls(chatProvider);
          }),
        ],
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    //

    Message message = Message.fromMap(snapshot.data() as Map<String, dynamic>);

    return Container(
      alignment: message.senderId == currenUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: message.senderId == currenUserId
          ? senderLayout(message)
          : receiverLayout(message),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    if (message.type == MessageType.Text.index) {
      return Text(
        message.message ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (message.type == MessageType.Image.index) {
      return CachedImage(
        message.message,
        height: 250,
        width: 250,
        radius: 10,
      );
    } else if (message.type == MessageType.Video.index) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VideoPlayerPage(message: message)));
        },
        child: const Icon(
          Icons.video_collection_outlined,
          size: 60,
        ),
      );
    } else if (message.type == MessageType.File.index) {
      return DocumentWidget(message: message);
    }
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls(ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context, chatProvider),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: chatProvider.textFieldController,
                  focusNode: textFieldFocus,
                  onChanged: (val) {
                    (val.isNotEmpty && val.trim() != "")
                        ? chatProvider.setWritingTo(true)
                        : chatProvider.setWritingTo(false);
                  },
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
          chatProvider.isWriting
              ? const SizedBox()
              : GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.camera_alt),
                  ),
                  onTap: () => chatProvider.sendFile(
                      source: ImageSource.camera,
                      receverId: widget.receiver.uid!,
                      type: MessageType.Image,
                      context: context),
                ),
          chatProvider.isWriting
              ? Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () async {
                      chatProvider.sendTextMessageMessage(
                          text: chatProvider.textFieldController.text,
                          recevierId: widget.receiver.uid!);

                      chatProvider.textFieldController.clear();
                    },
                  ))
              : const SizedBox()
        ],
      ),
    );
  }

  addMediaModal(context, ChatProvider chatProvider) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        builder: (context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: const Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Media Content",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                    child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        chatProvider.sendFile(
                            receverId: widget.receiver.uid!,
                            type: MessageType.File,
                            context: context);
                      },
                      icon: const Icon(Icons.file_copy),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: () {
                        chatProvider.sendFile(
                            source: ImageSource.gallery,
                            receverId: widget.receiver.uid!,
                            type: MessageType.Image,
                            context: context);
                      },
                      icon: const Icon(Icons.photo),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: () {
                        //
                        chatProvider.sendFile(
                            source: ImageSource.gallery,
                            receverId: widget.receiver.uid!,
                            type: MessageType.Video,
                            context: context);
                        //
                      },
                      icon: const Icon(Icons.video_file),
                      iconSize: 50,
                    ),
                  ],
                ))
              ],
            ),
          );
        });
  }
}
