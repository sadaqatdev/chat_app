import 'dart:convert';

class MUser {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;
  String? contact;

  MUser({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.contact,
  });

  // Map toMap(MUser user) {
  //   var data = <String, dynamic>{};
  //   data['uid'] = user.uid;
  //   data['name'] = user.name;
  //   data['email'] = user.email;
  //   data['username'] = user.username;
  //   data["status"] = user.status;
  //   data["state"] = user.state;
  //   data["profile_photo"] = user.profilePhoto;
  //   data['contact'] = user.contact;

  //   return data;
  // }

  // // Named constructor
  // MUser.fromMap(Map<String, dynamic> mapData) {
  //   uid = mapData['uid'];
  //   name = mapData['name'];
  //   email = mapData['email'];
  //   username = mapData['username'];
  //   status = mapData['status'];
  //   state = mapData['state'];
  //   profilePhoto = mapData['profile_photo'];
  //   contact = mapData['contact'];
  // }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (uid != null) {
      result.addAll({'uid': uid});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (username != null) {
      result.addAll({'username': username});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (state != null) {
      result.addAll({'state': state});
    }
    if (profilePhoto != null) {
      result.addAll({'profilePhoto': profilePhoto});
    }
    if (contact != null) {
      result.addAll({'contact': contact});
    }

    return result;
  }

  factory MUser.fromMap(Map<String, dynamic> map) {
    return MUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      username: map['username'],
      status: map['status'],
      state: map['state']?.toInt(),
      profilePhoto: map['profilePhoto'],
      contact: map['contact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MUser.fromJson(String source) => MUser.fromMap(json.decode(source));
}
