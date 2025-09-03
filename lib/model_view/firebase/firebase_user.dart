import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/evaluation_model.dart';
import 'package:handvibe/model/notification_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model/report_model.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/constant.dart';

class FireStoreUser {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  late ProfileModel profileModel;
  List<ProfileModel> allProfiles = [];
  List<NotificationModel> notifications = [];
  List<ReportModel> reportModels = [];
  List<EvaluationModel> evaluationModels = [];

  addUser(ProfileModel data, String uid) async {
    await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).set(data.toJson());
  }

  addDeletedAccount(ProfileModel profileModel) async {
    await firebaseFirestore.collection(Constants().deletedAccount).doc(profileModel.profileId).set({
      "email": profileModel.email,
      "nameAndSurname": profileModel.nameAndSurname,
      "deletedTime": DateTime.now().toString(),
    });
  }

  Future<ProfileModel?> getUserInfo(String uid) async {
    documentSnapshot = await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).get();
    if (documentSnapshot.exists) {
      return ProfileModel.fromJson(documentSnapshot.data()!);
    } else {
      debugPrint("The data for the given uid does not exist $uid");
      return null;
    }
  }

  updateUser(ProfileModel data, String uid) async {
    await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).update(data.toJson());
  }

  deleteUser(String uid) async {
    List<ChatHistoryModel> chatHistory = await FirebaseChat().getChatHistoryLimitless(uid);
    for (var i in chatHistory) {
      await FirebaseChat().deleteChatHistory(uid, i.receiverUid);
      debugPrint("${i.receiverUid} deleted");
    }
    await deleteAllNotification(uid);
    await SharedPreferencesMethods().clearAllInfo();
    await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).delete();
    await FirebaseAuth.instance.currentUser!.delete();
  }

  updateDeviceToken(String userId, List<String> deviceToken) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(Constants().userCollectionName).doc(userId);
    await documentReference.update({'deviceToken': deviceToken});
  }

  updateProducts(String userId, List<String> products) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(Constants().userCollectionName).doc(userId);
    await documentReference.update({'products': products});
  }

  updateSavedProducts(String userId, List<String> savedProducts) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(Constants().userCollectionName).doc(userId);
    await documentReference.update({'savedProducts': savedProducts});
  }

  updateLanguage(String userId, String selectedLanguage) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(Constants().userCollectionName).doc(userId);
    await documentReference.update({'selectedLanguage': selectedLanguage});
  }

  //UserInfo Operation

  Future<List<ProfileModel>> getAllUserInfo(String uid, int limit) async {
    try {
      querySnapshot = await firebaseFirestore.collection(Constants().userCollectionName).where("profileId", isNotEqualTo: uid).orderBy("joinDate", descending: true).limit(limit).get();

      allProfiles = querySnapshot.docs.map((doc) => ProfileModel.fromJson(doc.data())).toList();

      return allProfiles;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  Future<ProfileModel?> getProfileByEmail(String email) async {
    querySnapshot = await firebaseFirestore.collection(Constants().userCollectionName).where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      ProfileModel tempModel = ProfileModel.fromJson(doc.data());
      return tempModel;
    } else {
      return null;
    }
  }

  Future<List<ProfileModel>> getSearchedProfileList(String value, String uid) async {
    try {
      querySnapshot = await firebaseFirestore.collection(Constants().userCollectionName).where('nameAndSurname', isGreaterThanOrEqualTo: value).limit(10).get();

      allProfiles = querySnapshot.docs.map((doc) => ProfileModel.fromJson(doc.data())).toList();

      return allProfiles;
    } catch (e) {
      debugPrint("Error in getSearchedProfileList: $e");
      return []; // or throw an exception based on your error handling strategy
    }
  }

  //Notifications
  Future<List<NotificationModel>> getAllNotifications(String uid, int limit) async {
    querySnapshot =
        await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).orderBy('dateTime', descending: true).limit(limit).get();
    notifications = querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
    return notifications;
  }

  Stream<QuerySnapshot> getNotificationHistory(String myId) {
    return firebaseFirestore.collection(Constants().userCollectionName).doc(myId).collection(Constants().notifications).snapshots();
  }

  addNotification(NotificationModel data, String uid, String notificationID) async {
    await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).doc(notificationID).set(data.toJson());
  }

  deleteNotification(String uid, String notificationID) async {
    await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).doc(notificationID).delete();
  }

  deleteAllNotification(String uid) async {
    if (notifications.isEmpty) {
      querySnapshot = await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).get();
      notifications = querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
      debugPrint("Geldi");
    }
    for (var document in notifications) {
      await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).doc(document.notificationId).delete();
    }
  }

  makeAllSeen(String uid) async {
    querySnapshot = await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).where("isSeen", isEqualTo: false).get();
    List<NotificationModel> notificationList = querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
    for (var i in notificationList) {
      await firebaseFirestore.collection(Constants().userCollectionName).doc(uid).collection(Constants().notifications).doc(i.notificationId).update({"isSeen": true});
    }
  }

  //User Phone

  updateUserPhoneVerified(String userId, bool phoneVerified, String phoneNumber, String phoneCode) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(Constants().userCollectionName).doc(userId);
    await documentReference.update({"phoneVerified": phoneVerified});
    await documentReference.update({"phoneNumber": phoneNumber});
    await documentReference.update({"phoneCode": phoneCode});
  }

  //Report Operations

  Future<List<ReportModel>> getReportModelList(String uid) async {
    try {
      querySnapshot = await firebaseFirestore.collection(Constants().report).get();
      reportModels = querySnapshot.docs.map((doc) => ReportModel.fromJson(doc.data())).toList();
      return reportModels;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  addReportProfile(ReportModel reportModel) async {
    await firebaseFirestore.collection(Constants().report).doc(reportModel.reportId).set(reportModel.toJson());
  }

  deleteReport(ReportModel reportModel) async {
    await firebaseFirestore.collection(Constants().report).doc(reportModel.reportId).delete();
  }

  getFollowList(List<String> followProfileList, int limit) async {
    try {
      for (var i in followProfileList) {
        documentSnapshot = await firebaseFirestore.collection(Constants().userCollectionName).doc(i).get();
        if (documentSnapshot.exists) {
          allProfiles.add(ProfileModel.fromJson(documentSnapshot.data()!));
        }
      }
      return allProfiles;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  addProfileEvaluate(EvaluationModel evaluationModel, String evaluatorId, String sellerId) async {
    try {
      await firebaseFirestore.collection(Constants().userCollectionName).doc(sellerId).collection(Constants().evaluate).doc(evaluatorId).set(evaluationModel.toJson());
      debugPrint("Eklendi");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  deleteProfileEvaluate(EvaluationModel evaluationModel) async {
    try {
      await firebaseFirestore.collection(Constants().userCollectionName).doc(evaluationModel.sellerId).collection(Constants().evaluate).doc(evaluationModel.evaluatorId).delete();
      debugPrint("Silindi");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  getAllSellerEvaluationList(String sellerId, int limit) async {
    try {
      querySnapshot =
          await firebaseFirestore.collection(Constants().userCollectionName).doc(sellerId).collection(Constants().evaluate).orderBy("createdAt", descending: true).limit(limit).get();

      evaluationModels = querySnapshot.docs.map((doc) => EvaluationModel.fromJson(doc.data())).toList();

      return evaluationModels;
    } catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }

  updateProfileEvaluate(EvaluationModel evaluationModel)async{
    try{
      await firebaseFirestore.collection(Constants().userCollectionName).doc(evaluationModel.sellerId).collection(Constants().evaluate).doc(evaluationModel.evaluatorId).update(evaluationModel.toJson());
    }
    catch (e) {
      debugPrint("Error in getAllUserInfo: $e");
      return [];
    }
  }


}
