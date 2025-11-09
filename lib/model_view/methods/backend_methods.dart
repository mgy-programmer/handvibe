import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handvibe/model/notification_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_storage.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/template/verify_dialog.dart';
import 'package:provider/provider.dart';

class BackEndMethods {
  List<String> likeList = [];
  List<String> savedProfile = [];
  late bool isLiked;

  sendNotification(bool isExist, String targetProfile, ProfileModel myProfile, String status, String contentId) async {
    if (isExist) {
      String notificationId = UsefulMethods().generate32BitKey(targetProfile);
      await FireStoreUser().addNotification(
        NotificationModel(notificationId, targetProfile, myProfile.profileId, false, status, contentId, DateTime.now()),
        targetProfile,
        notificationId,
      );
    }
  }

  updateDeviceToken(ProfileModel myProfile) async {
    List<String> deviceTokenList = myProfile.deviceToken;
    String deviceToken = await SharedPreferencesMethods().getDeviceToken();
    deviceTokenList.remove(deviceToken);
    await FireStoreUser().updateDeviceToken(myProfile.profileId, deviceTokenList);
  }

  updateUserProfile(BuildContext context, File? selectedImage, String userId, ProfileModel profileModel) async {
    String uploadedProfileUrl = "";
    if (selectedImage != null) {
      uploadedProfileUrl = await FirebaseStorageMethods().addImageToFirebase(
        selectedImage,
        userId,
        Constants().storageUserProfile,
        60,
      );
      profileModel.profileImagePath = uploadedProfileUrl;
    }
    await FireStoreUser().updateUser(
      profileModel,
      userId
    );
    if (context.mounted) Provider.of<UserProvider>(context, listen: false).getMyProfile(userId);
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => VerifyDialog(title: AppLocalizations.of(context)!.translate("saved_changes"), content: ""),
      );
    }
  }
}
