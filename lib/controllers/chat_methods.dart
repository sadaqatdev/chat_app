import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/muser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';
import '../utils/gloable_utils.dart';

class ChatMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference _messageCollection =
      _firestore.collection('messages');

  final CollectionReference _userCollection = _firestore.collection('users');
  // get current user details
  Future<MUser?> getUserDetails() async {
    User? currentUser = await getCurrentUser();
    if (currentUser != null) {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(currentUser.uid).get();

      return documentSnapshot.exists
          ? MUser.fromMap(documentSnapshot.data() as Map<String, dynamic>)
          : null;
    } else {
      return null;
    }
  }

  // fetch all user from user collection to display in search page
  Future<List<MUser>> fetchAllUsers(User currentUser) async {
    List<MUser> userList = <MUser>[];

    QuerySnapshot querySnapshot =
        await _firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(MUser.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    return userList;
  }

  // get the latest message using stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(recevierUid) {
    return _firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(recevierUid)
        .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots();
  }

  // get user details from user collection
  Future<MUser?> getUserDetailsById(id) async {
    try {
      //

      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();

      return MUser.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      dp(msg: "Error in user get", args: e);
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  // check wather user record  exits  in users collections or not and rturn  bool value based on thos record
  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await _firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.isEmpty ? true : false;
  }

  // add user data to firestore users collection
  Future<void> addDataToDb(User currentUser) async {
    //

    String username = currentUser.email!.split('@')[0];

    MUser user = MUser(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    _firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap());
  }

  // add message to firestore
  Future addMessageToDb(Message message) async {
    var map = message.toMap();
    // this document can show messages to sender
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);
    // this add data to user collection which is use to disply chat list on home page
    addToContacts(senderId: message.senderId!, receiverId: message.receiverId!);
    // this document show message to reciver
    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  addToContacts({required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  // fetch all contacts of current user from firestore contacts collections
  // from this record we display the current contacts of user
  Stream<QuerySnapshot> fetchContacts({String? userId}) =>
      _userCollection.doc(userId).collection(CONTACTS_COLLECTION).snapshots();
}
