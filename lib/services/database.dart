import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUsersByUsername(String username) async{

    return await Firestore.instance.collection("Euonia")
        .where("name",isEqualTo: username)
        .getDocuments();

  }
  getUsersByUserEmail(String userEmail) async{

    return await Firestore.instance.collection("Euonia")
        .where("Email",isEqualTo: userEmail)
        .getDocuments();

  }
  uploadUserInfo(userMap){
  Firestore.instance.collection("Euonia")
      .add(userMap).catchError((e){
      print(e.toString());
    });
}

  createChatRoom(String chatRoomId,chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString);
    });
  }
 addConversationMessages(String chatRoomId,messageMap){
  Firestore.instance.collection("ChatRoom")
  .document(chatRoomId)
    .collection("chats")
      .add(messageMap)
      .catchError((e){
        print(e.toString());
  });
  }
  getConversationMessages(String chatRoomId)async{
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
    .orderBy("time",descending: false)
        .snapshots();

  }
  getChatRooms(String userName)async{
  return await Firestore.instance
      .collection("ChatRoom")
      .where("users",arrayContains: userName)
      .snapshots();
  }
}