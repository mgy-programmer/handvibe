import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String messageID;
  late String senderUID;
  late String receiverUID;
  late String messageContent;
  late bool fromMe;
  late bool? isSeen;
  late DateTime sendTime;

  ChatModel(this.messageID, this.senderUID, this.receiverUID, this.messageContent, this.sendTime, this.fromMe, {this.isSeen = false});

  ChatModel.fromJson(Map json) {
    messageID = json["messageID"];
    senderUID = json["senderUID"];
    receiverUID = json["receiverUID"];
    messageContent = json["messageContent"];
    fromMe = json["fromMe"];
    isSeen = json["isSeen"];
    sendTime = json["sendTime"].toDate();
  }

  toJson() {
    return {
      "messageID": messageID,
      "senderUID": senderUID,
      "receiverUID": receiverUID,
      "messageContent": messageContent,
      "fromMe": fromMe,
      "isSeen": isSeen ?? false,
      "sendTime": sendTime,
    };
  }

  ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    messageID = snapshot["messageID"];
    senderUID = snapshot["senderUID"];
    receiverUID = snapshot["receiverUID"];
    messageContent = snapshot["messageContent"];
    fromMe = snapshot["fromMe"];
    isSeen = snapshot["isSeen"];
    sendTime = snapshot["sendTime"].toDate();
  }
}