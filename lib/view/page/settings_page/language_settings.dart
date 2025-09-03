import 'package:flutter/material.dart';
import 'package:handvibe/main.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/language_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:provider/provider.dart';

class SettingsLanguage extends StatefulWidget {
  final String uid;
  const SettingsLanguage({super.key, required this.uid});

  @override
  State<SettingsLanguage> createState() => _SettingsLanguageState();
}

class _SettingsLanguageState extends State<SettingsLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("language"),
          style: TextFont().ralewayBoldMethod(
            18,
            ColorBank().black,
            context,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate("system_language"),
              style: TextFont().ralewayRegularMethod(17, ColorBank().black,
                  context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: ColorBank().primary,
              size: ScreenSizeUtil().getCalculateWith(context, 20),
            ),
            onTap: () async {
              await SharedPreferencesMethods().saveSelectedLanguage("");
              String langCode = "";
              if(context.mounted) langCode = AppLocalizations.of(context)!.locale.languageCode;
              await FireStoreUser().updateLanguage(widget.uid, langCode);
              if(context.mounted){
                Provider.of<LanguageProvider>(context, listen: false).setLanguage("");
                UsefulMethods().navigatorPushAndNeverComeBackMethod(context, const MyApp(langCode: ""));
              }
            },
          ),
          ListTile(
            title: Text(
              "English",
              style: TextFont().ralewayRegularMethod(17, ColorBank().black,
                  context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: ColorBank().primary,
              size: ScreenSizeUtil().getCalculateWith(context, 20),
            ),
            onTap: () async {
              await SharedPreferencesMethods().saveSelectedLanguage("en");
              await FireStoreUser().updateLanguage(widget.uid, "en");
              if(context.mounted){
                Provider.of<LanguageProvider>(context, listen: false).setLanguage("en");
                UsefulMethods().navigatorPushAndNeverComeBackMethod(context, const MyApp(langCode: "en"));
              }
            },
          ),
          ListTile(
            title: Text("Türkçe", style: TextFont().ralewayRegularMethod(17, ColorBank().black,
                context)),
            subtitle: Text("Turkish", style: TextFont().ralewayRegularMethod(17, ColorBank().black,
                context)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: ColorBank().primary,
              size: ScreenSizeUtil().getCalculateWith(context, 20),
            ),
            onTap: () async {
              await SharedPreferencesMethods().saveSelectedLanguage("tr");
              await FireStoreUser().updateLanguage(widget.uid, "tr");
              if(context.mounted){
                Provider.of<LanguageProvider>(context, listen: false).setLanguage("tr");
                UsefulMethods().navigatorPushAndNeverComeBackMethod(context, const MyApp(langCode: "tr"));
              }
            },
          ),
        ],
      ),
    );
  }
}
