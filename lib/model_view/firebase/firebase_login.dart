import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/useful_methods.dart';

class FirebaseLogin {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserCredential? userCredential;

  Future<ReturnValue> signUp(String languageCode, {required String email, required String password, required String name, required String surname}) async {
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential!.user != null) {
        await userCredential!.user!.sendEmailVerification();
        await FireStoreUser().addUser(
          ProfileModel(
            email,
            name,
            surname,
            "$name $surname",
            "${email.split("@").first}${UsefulMethods().generateCustomBitKey(16)}",
            [],
            languageCode,
            DateTime.now(),
            Platform.operatingSystem,
            profileId: userCredential!.user!.uid,
          ),
          userCredential!.user!.uid,
        );
        return ReturnValue(true, "");
      } else {
        return ReturnValue(false, "_");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return ReturnValue(false, e.toString().split("] ").last);
    }
  }

  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified) {
        await SharedPreferencesMethods().setUserEmail(userCredential.user!.email!);
        await SharedPreferencesMethods().setUserID(userCredential.user!.uid);
        final token = await userCredential.user!.getIdToken() ?? "";
        await SharedPreferencesMethods().setUserToken(token);
        String deviceToken = ""; //Todo: await NotificationServices().getUserToken();
        await SharedPreferencesMethods().saveDeviceToken(deviceToken);
        ProfileModel? myProfile = await FireStoreUser().getUserInfo(userCredential.user!.uid);
        List<String> deviceTokenList = [];
        if (myProfile != null) {
          deviceTokenList = myProfile.deviceToken;
          if (!deviceTokenList.contains(deviceToken)) {
            deviceTokenList.add(deviceToken);
          }
        }
        await FireStoreUser().updateDeviceToken(userCredential.user!.uid, deviceTokenList);

        return {"success": token, "verify": true, "myId": userCredential.user!.uid};
      } else {
        return {"success": "", "verify": false, "myId": ""};
      }
    } catch (error) {
      return {
        "success": "",
        "error": "$error",
      };
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await SharedPreferencesMethods().clearAllInfo();
  }

  Future<String> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  sendVerificationMail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (!user.emailVerified) {
        try {
          await user.sendEmailVerification();
        } catch (e) {
          debugPrint("Error: $e");
        }
      } else {}
    }
  }
}

class ReturnValue {
  late bool resultValue;
  late String desc;
  ReturnValue(this.resultValue, this.desc);
}
