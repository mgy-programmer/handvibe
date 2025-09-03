import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/profile_banner_text.dart';
import 'package:handvibe/view/page/profile_pages/follow_list_page.dart';

class UserInfo extends StatelessWidget {
  final ProfileModel myProfile;
  const UserInfo({super.key, required this.myProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(-1, 0),
      margin: EdgeInsets.only(
        left: ScreenSizeUtil().getCalculateWith(context, 20),
        right: ScreenSizeUtil().getCalculateWith(context, 20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context)!.translate("hi")}, ${myProfile.name}",
            style: TextFont().ralewayBoldMethod(24, ColorBank().black, context),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 5),
            ),
            alignment: Alignment(-1, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileBannerText(
                  count: myProfile.following.length.toString(),
                  text: AppLocalizations.of(context)!.translate("following"),
                  onTap: () async {
                    await UsefulMethods().navigatorPushMethod(
                      context,
                      FollowListPage(followList: myProfile.following,),
                    );
                  },
                ),
                ProfileBannerText(
                  count: myProfile.followers.length.toString(),
                  text: AppLocalizations.of(context)!.translate("followers"),
                  onTap: () async {
                    await UsefulMethods().navigatorPushMethod(
                      context,
                      FollowListPage(followList: myProfile.followers,),
                    );
                  },
                ),
                ProfileBannerText(
                  count: myProfile.products.length.toString(),
                  text: AppLocalizations.of(context)!.translate("products"),
                  onTap: () async {

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
