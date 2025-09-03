import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/settings_option.dart';
import 'package:handvibe/view/page/login_pages/splashscreen.dart';
import 'package:handvibe/view/page/profile_pages/edit_profile.dart';
import 'package:handvibe/view/template/question_dialog.dart';
import 'package:handvibe/view/template/reauth_dialog.dart';
import 'package:handvibe/view/template/warning_dialog.dart';

class ProfileSettings extends StatefulWidget {
  final ProfileModel myProfile;

  const ProfileSettings({super.key, required this.myProfile});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  Progressing progressing = Progressing.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("profile_settings"),
          style: TextFont().ralewayBoldMethod(
            18,
            ColorBank().black,
            context,
          ),
        ),
      ),
      body: ListView(
        children: [
          SettingsOption(
            title: AppLocalizations.of(context)!.translate("edit_profile"),
            textColor: ColorBank().black,
            fontSize: 18,
            onTap: () {
              UsefulMethods().navigatorPushMethod(
                context,
                EditProfile(
                  myProfile: widget.myProfile,
                ),
              );
            },
          ),
          SettingsOption(
            title: AppLocalizations.of(context)!.translate("delete_account"),
            textColor: ColorBank().red,
            fontSize: 18,
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return QuestionDialog(
                      content: AppLocalizations.of(context)!.translate("delete_account_info"),
                      yesMethod: () async {
                        setState(() {
                          progressing = Progressing.busy;
                        });
                        bool isOK = false;
                        await showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(builder: (context, setState) {
                            return ReAuthDialog(
                              email: widget.myProfile.email,
                              reAuthFunc: (value) async {
                                isOK = value;
                                Navigator.pop(context);
                              },
                            );
                          }),
                        );
                        if (isOK) {
                          await FireStoreUser().addDeletedAccount(widget.myProfile);
                          await FireStoreUser().deleteUser(widget.myProfile.profileId);
                          if (context.mounted) UsefulMethods().navigatorPushAndNeverComeBackMethod(context, const SplashScreen());
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => WarningDialog(
                                dialogTitle: AppLocalizations.of(context)!.translate("account_not_deleted"),
                                content: AppLocalizations.of(context)!.translate("account_not_deleted_content"),
                              ),
                            );
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                        debugPrint("bitti");
                        setState(() {
                          progressing = Progressing.idle;
                        });
                      },
                      progressing: progressing,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
