import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/notification_services.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/page/base_screen.dart';
import 'package:handvibe/view/template/warning_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseSocialAuth {
  signInWithGoogle(BuildContext context) async {
    try {
      UserCredential? userCredential = await googleSignIn();
      if (userCredential != null) {
        String languageCode = "";
        if (context.mounted) {
          languageCode = AppLocalizations.of(context)!.locale.languageCode;
        }
        ProfileModel? profileModel;
        if (userCredential.user != null) {
          profileModel = await FireStoreUser().getProfileByEmail(userCredential.user!.email!);
          if (profileModel == null) {
            profileModel = ProfileModel(
              profileId: userCredential.user!.uid,
              userCredential.user!.email!,
              userCredential.user!.displayName!,
              "",
              userCredential.user!.displayName!,
              "${userCredential.user!.email!.split("@").first}${UsefulMethods().generateCustomBitKey(16)}",
              [],
              languageCode,
              DateTime.now(),
              Platform.operatingSystem,
              profileImagePath: userCredential.user!.photoURL ?? "",
              phoneNumber: userCredential.user!.phoneNumber ?? "",
            );
            await FireStoreUser().addUser(profileModel, userCredential.user!.uid);
          }
          await SharedPreferencesMethods().setUserEmail(userCredential.user!.email!);
          await SharedPreferencesMethods().setUserID(userCredential.user!.uid);
          final token = await userCredential.user!.getIdToken() ?? "";
          await SharedPreferencesMethods().setUserToken(token);
          String deviceToken = await NotificationServices().getUserToken();
          await SharedPreferencesMethods().saveDeviceToken(deviceToken);

          //Send device token for getting notification
          ProfileModel? myProfile = await FireStoreUser().getUserInfo(userCredential.user!.uid);
          List<String> deviceTokenList = [];
          if (myProfile != null) {
            deviceTokenList = myProfile.deviceToken;
            if (!deviceTokenList.contains(deviceToken)) {
              deviceTokenList.add(deviceToken);
            }
          }
          await FireStoreUser().updateDeviceToken(userCredential.user!.uid, deviceTokenList);

          if (context.mounted) {
            UsefulMethods().navigatorPushAndNeverComeBackMethod(
              context,
              BaseScreen(
                myId: userCredential.user!.uid,
              ),
            );
          }
        } else {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => WarningDialog(
                dialogTitle: AppLocalizations.of(context)!.translate("error"),
                content: AppLocalizations.of(context)!.translate("general_error_message"),
              ),
            );
          }
        }
        return profileModel;
      } else {
        return null;
      }
    } on Exception catch (e) {
      // TODO
      debugPrint('exception->$e');
      return null;
    }
  }

  Future<UserCredential?> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<UserCredential?> signInApple() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    try {
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (appleCredential.identityToken != null) {
        AuthCredential credential = AppleAuthProvider.credential(appleCredential.identityToken!);
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        debugPrint("it's null value");
        return null;
      }
    } catch (e) {
      debugPrint("Error during Apple sign-in: $e");
      return null;
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      String name = "Handvibe User";
      String email = "handvibeuser@handvibe.com";
      // Attempt to sign in with Apple
      await signInApple();
      /*if(context.mounted){
        await showDialog(
          context: context,
          builder: (context) => AskEmailAndDisplayNameDialog(
            returnedValue: (rName, rEmail) {
              name = rName;
              email = rEmail;
            },
          ),
        );
      }*/
      if(name != ""){

        String languageCode = "";


        if (context.mounted) languageCode = AppLocalizations.of(context)!.locale.languageCode;

        // Fetch or create the user profile
        ProfileModel? profileModel = await FireStoreUser().getProfileByEmail(email);
        String uid = profileModel?.profileId ?? UsefulMethods().generateCustomBitKey(32);

        if (profileModel == null) {
          profileModel = ProfileModel(
            profileId: uid,
            "",
            name,
            "",
            name,
            "$name${UsefulMethods().generateCustomBitKey(16)}",
            [],
            languageCode,
            DateTime.now(),
            Platform.operatingSystem,
            profileImagePath: "",
            phoneNumber: "",
          );
          await FireStoreUser().addUser(profileModel, uid);
        }

        // Store user data locally
        await SharedPreferencesMethods().setUserEmail(email);
        await SharedPreferencesMethods().setUserID(uid);

        String token = UsefulMethods().generateCustomBitKey(10);
        await SharedPreferencesMethods().setUserToken(token);

        // Handle device token
        final deviceToken = await NotificationServices().getUserToken();
        if (deviceToken.isNotEmpty) {
          await SharedPreferencesMethods().saveDeviceToken(deviceToken);

          final myProfile = await FireStoreUser().getUserInfo(uid);
          final deviceTokenList = myProfile?.deviceToken ?? [];
          if (!deviceTokenList.contains(deviceToken)) {
            deviceTokenList.add(deviceToken);
            await FireStoreUser().updateDeviceToken(uid, deviceTokenList);
          }
        }

        // Navigate to the home page
        if (context.mounted) {
          UsefulMethods().navigatorPushAndNeverComeBackMethod(
            context,
            BaseScreen(
              myId: uid,
            ),
          );
        }
      }
    } catch (e) {
      // Log error and display user-friendly error message
      debugPrint("Error during Apple sign-in: $e");
      if (context.mounted) {
        _showErrorDialog(context, "error", "apple_signup_issue");
      }
    }
  }

  void _showErrorDialog(BuildContext context, String titleKey, String contentKey) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => WarningDialog(
          dialogTitle: AppLocalizations.of(context)!.translate(titleKey),
          content: AppLocalizations.of(context)!.translate(contentKey),
        ),
      );
    }
  }
}
