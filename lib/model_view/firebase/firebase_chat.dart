import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/chat_model.dart';
import 'package:handvibe/utility/constant.dart';

class FirebaseChat {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamQuerySnapshot;
  List<ChatModel> chats = [];
  List<ChatHistoryModel> chatHistories = [];

  sendMessage(ChatModel chatModel, String chatID) async {
    await firebaseFirestore
        .collection(Constants().userCollectionName)
        .doc(chatModel.senderUID)
        .collection(Constants().conservation)
        .doc(chatModel.receiverUID)
        .collection(Constants().chat)
        .doc(chatID)
        .set(chatModel.toJson());
    await firebaseFirestore
        .collection(Constants().userCollectionName)
        .doc(chatModel.senderUID)
        .collection(Constants().conservation)
        .doc(chatModel.receiverUID)
        .set(ChatHistoryModel(
                chatModel.receiverUID, chatModel.fromMe, chatModel.fromMe ? true : false, chatModel.messageContent, chatModel.sendTime, false)
            .toJson());
  }

  getConversationByReceiverId(String myId, String receiverId) async {
    querySnapshot = await firebaseFirestore
        .collection(Constants().userCollectionName)
        .doc(myId)
        .collection(Constants().conservation)
        .doc(receiverId)
        .collection(Constants().chat)
        .get();
    chats = querySnapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList();
    return chats;
  }

  Stream<QuerySnapshot> getConversationCollectionByReceiverId(String myId, String receiverId, int limit) {
    return firebaseFirestore
        .collection(Constants().userCollectionName)
        .doc(myId)
        .collection(Constants().conservation)
        .doc(receiverId)
        .collection(Constants().chat)
        .limit(limit)
        .orderBy("sendTime", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversationHistory(String myId) {
    debugPrint("MyId: $myId");
    streamQuerySnapshot = firebaseFirestore.collection(Constants().userCollectionName).doc(myId).collection(Constants().conservation).snapshots();
    return streamQuerySnapshot;
  }

  Future<List<ChatHistoryModel>> getChatHistory(String myId, int limit) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().userCollectionName)
          .doc(myId)
          .collection(Constants().conservation)
          .orderBy('lastMessageTime', descending: true)
          .limit(limit)
          .get();
      chatHistories = querySnapshot.docs.map((doc) => ChatHistoryModel.fromJson(doc.data())).toList();
      return chatHistories;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List<ChatHistoryModel>> getChatHistoryLimitless(String myId) async {
    try {
      querySnapshot = await firebaseFirestore
          .collection(Constants().userCollectionName)
          .doc(myId)
          .collection(Constants().conservation)
          .orderBy('lastMessageTime', descending: true)
          .get();
      chatHistories = querySnapshot.docs.map((doc) => ChatHistoryModel.fromJson(doc.data())).toList();
      return chatHistories;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<void> deleteChatHistory(String uid, String receiverId) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection(Constants().userCollectionName);
    await userCollection.doc(uid).collection(Constants().conservation).doc(receiverId).collection(Constants().chat).get().then((querySnapshot) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        documentSnapshot.reference.delete();
      }
    });
    await userCollection.doc(uid).collection(Constants().conservation).doc(receiverId).delete();
  }

  updateChatHistory(ChatHistoryModel chatHistoryModel, String uid) async {
    await firebaseFirestore
        .collection(Constants().userCollectionName)
        .doc(uid)
        .collection(Constants().conservation)
        .doc(chatHistoryModel.receiverUid)
        .set(chatHistoryModel.toJson());
  }
}
