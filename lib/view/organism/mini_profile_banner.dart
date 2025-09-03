import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/atom/give_break.dart';
import 'package:handvibe/view/atom/hobi_text.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/molecule/profile_image.dart';

class MiniProfileBanner extends StatelessWidget {
  final ProfileModel profileModel;
  final Function() followAction;
  final Function() goToProfileAction;
  final bool follow;
  final String myId;

  const MiniProfileBanner(
      {super.key, required this.profileModel, required this.followAction, required this.goToProfileAction, required this.follow, required this.myId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorBank().white.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorBank().hinTextColor,
        ),
      ),
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 20),
      ),
      padding: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImage(
                profileImagePath: profileModel.profileImagePath,
                height: 80,
                width: 80,
                isShadow: true,
                onProfileImageTap: goToProfileAction,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HobiText(
                    text: profileModel.nameAndSurname,
                    width: 170,
                  ),
                  GiveBreak(
                    height: 10,
                  ),
                  HobiButton(
                    text: AppLocalizations.of(context)!.translate("seller_profile"),
                    backgroundColor: ColorBank().info,
                    onTap: goToProfileAction,
                    textColor: ColorBank().white,
                    textFont: 16,
                    width: 150,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
