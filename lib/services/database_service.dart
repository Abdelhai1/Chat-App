import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  // ignore: use_function_type_syntax_for_parameters
  DatabaseService({this.uid});

  //refrences
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  //savingtheuserdata
  Future saveUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilepic": "http://",
      "uid": uid
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating a group
  Future creatGroup(String username, String id, String groupname) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupname": groupname,
      "groupicon": "",
      "admin": "${id}_$username",
      "members": [],
      "groupid": "",
      "recentmessage": "",
      "recentmessagesender": "",
    });
    //update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"]),
      "groupid": groupDocumentReference.id,
    });

    DocumentReference userDocumentRefrence = userCollection.doc(uid);
    return await userDocumentRefrence.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupname"])
    });
  }

  //getting the chats
  getChats(String groupid) async {
    return groupCollection
        .doc(groupid)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupid) async {
    DocumentReference d = groupCollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //getting the members
  getGroupMembers(groupid) async {
    return groupCollection.doc(groupid).snapshots();
  }

  //search
  searchByname(String groupname) async {
    final result =
        await groupCollection.where("groupname", isEqualTo: groupname).get();
    return result;
  }

  //fonction == bool
  Future<bool> isUserJoined(
      String groupname, String groupid, String username) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupid}_$groupname")) {
      return true;
    } else {
      return false;
    }
  }

  //group join/exit
  Future groupJoin(String groupid, String username, String groupname) async {
    //doc refrence
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //remove group or rejoin
    if (groups.contains("${groupid}_$groupname")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupid}_$groupname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupid}_$groupname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  //send message
  sendMessage(String groupid, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupid).collection("messages").add(chatMessageData);
    groupCollection.doc(groupid).update({
      "recentmessage": chatMessageData['message'],
      "recentmessagesender": chatMessageData['sender'],
      "recentmessageTime": chatMessageData['time'].toString(),
    });
  }
}
