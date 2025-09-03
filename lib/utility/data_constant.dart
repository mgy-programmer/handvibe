import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';

class DataConstant {
  ProfileModel getTempProfile(BuildContext context) {
    return ProfileModel(
      "",
      AppLocalizations.of(context)!.translate("handvibe_user"),
      "",
      AppLocalizations.of(context)!.translate("handvibe_user"),
      "handvibeuser",
      [],
      "tr",
      DateTime.now(),
      "",
    );
  }
}