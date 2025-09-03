import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHistoryModel {
  late String receiverUid;
  late bool fromMe;
  late bool isSeen;
  late String lastMessage;
  late DateTime lastMessageTime;
  late bool isArchived;


  ChatHistoryModel(this.receiverUid, this.fromMe, this.isSeen, this.lastMessage, this.lastMessageTime, this.isArchived);

  ChatHistoryModel.fromJson(Map json) {
    receiverUid = json["receiverUid"];
    fromMe = json["fromMe"];
    isSeen = json["isSeen"];
    lastMessage = json["lastMessage"];
    lastMessageTime = json["lastMessageTime"].toDate();
    isArchived = json["isArchived"];
  }

  toJson() {
    return {
      "receiverUid": receiverUid,
      "fromMe": fromMe,
      "isSeen": isSeen,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
      "isArchived": isArchived,
    };
  }


  ChatHistoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    receiverUid = snapshot["receiverUid"];
    fromMe = snapshot["fromMe"];
    isSeen = snapshot["isSeen"];
    lastMessage = snapshot["lastMessage"];
    lastMessageTime = DateTime.parse(snapshot["lastMessageTime"].toString());
    isArchived = snapshot["isArchived"];
  }
}