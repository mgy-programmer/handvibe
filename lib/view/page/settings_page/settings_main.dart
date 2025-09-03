import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/settings_option.dart';
import 'package:handvibe/view/page/settings_page/faq.dart';
import 'package:handvibe/view/page/settings_page/language_settings.dart';
import 'package:handvibe/view/page/settings_page/profile_settings.dart';

class SettingsMain extends StatefulWidget {
  final ProfileModel myProfile;
  const SettingsMain({super.key, required this.myProfile});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("settings"),
          style: TextFont().ralewayRegularMethod(18, ColorBank().info, context),
        ),
      ),
      body: ListView(
        children: [
          SettingsOption(
            title: AppLocalizations.of(context)!.translate("profile_settings"),
            textColor: ColorBank().black,
            fontSize: 18,
            onTap: (){
              UsefulMethods().navigatorPushMethod(context, ProfileSettings(myProfile: widget.myProfile));
            },
          ),
          SettingsOption(
            title: AppLocalizations.of(context)!.translate("language"),
            textColor: ColorBank().black,
            fontSize: 18,
            onTap: (){
              UsefulMethods().navigatorPushMethod(context, SettingsLanguage(uid: widget.myProfile.profileId));
            },
          ),
          SettingsOption(
            title: AppLocalizations.of(context)!.translate("faq"),
            textColor: ColorBank().black,
            fontSize: 18,
            onTap: (){
              UsefulMethods().navigatorPushMethod(context, FAQPage());
            },
          ),
        ],
      ),
    );
  }
}
