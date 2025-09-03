import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_login.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/my_profile_icon.dart';
import 'package:handvibe/view/molecule/profile_image.dart';
import 'package:handvibe/view/page/base_screen.dart';
import 'package:handvibe/view/page/profile_pages/edit_profile.dart';
import 'package:handvibe/view/page/settings_page/settings_main.dart';
import 'package:handvibe/view/template/question_dialog.dart';

class MyProfileBanner extends StatefulWidget {
  final ProfileModel myProfile;

  const MyProfileBanner({super.key, required this.myProfile});

  @override
  State<MyProfileBanner> createState() => _MyProfileBannerState();
}

class _MyProfileBannerState extends State<MyProfileBanner> {
  Progressing progressing = Progressing.idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorBank().white.withValues(alpha: .6),
      ),
      padding: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        right: ScreenSizeUtil().getCalculateWith(context, 10),
        left: ScreenSizeUtil().getCalculateWith(context, 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImage(
            profileImagePath: widget.myProfile.profileImagePath,
            height: 50,
            width: 50,
            isShadow: true,
            onProfileImageTap: () {},
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                ),
                child: MyProfileIcon(
                  onTap: () {
                    UsefulMethods().navigatorPushMethod(
                      context,
                      SettingsMain(
                        myProfile: widget.myProfile,
                      ),
                    );
                  },
                  iconPath: ImageConstant().settingsIcon,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                ),
                child: MyProfileIcon(
                  onTap: () {
                    UsefulMethods().navigatorPushMethod(
                      context,
                      EditProfile(
                        myProfile: widget.myProfile,
                      ),
                    );
                  },
                  iconPath: ImageConstant().editIcon,
                  iconSize: 20,
                  padding: 10,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                ),
                child: MyProfileIcon(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => QuestionDialog(
                        content: AppLocalizations.of(context)!.translate("exit_message"),
                        yesMethod: () async {
                          setState(() {
                            progressing = Progressing.busy;
                          });
                          await FirebaseLogin().signOut();
                          if (context.mounted) {
                            UsefulMethods().navigatorPushAndNeverComeBackMethod(
                              context,
                              BaseScreen(
                                myId: "",
                              ),
                            );
                          }
                          setState(() {
                            progressing = Progressing.idle;
                          });
                        },
                        progressing: progressing,
                      ),
                    );
                  },
                  iconPath: ImageConstant().exitIcon,
                  iconSize: 20,
                  padding: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
