import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/hobi_text.dart';
import 'package:handvibe/view/atom/mini_button.dart';
import 'package:handvibe/view/molecule/profile_banner_text.dart';
import 'package:handvibe/view/molecule/profile_image.dart';
import 'package:handvibe/view/page/profile_pages/follow_list_page.dart';

class ProfileBanner extends StatelessWidget {
  final ProfileModel profile;
  final Function() followAction;
  final bool follow;

  const ProfileBanner({super.key, required this.profile, required this.followAction, required this.follow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorBank().white.withValues(alpha: .6),
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
                profileImagePath: profile.profileImagePath,
                height: 80,
                width: 80,
                isShadow: true,
                onProfileImageTap: () {},
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HobiText(text: "${profile.name} ${profile.surname}"),
                  Container(
                    width: ScreenSizeUtil().getCalculateWith(context, 200),
                    margin: EdgeInsets.only(
                      bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: ScreenSizeUtil().getCalculateWith(context, 20),
                          ),
                          child: ProfileBannerText(
                            count: profile.following.length.toString(),
                            text: AppLocalizations.of(context)!.translate("following"),
                            onTap: () async {
                              await UsefulMethods().navigatorPushMethod(
                                context,
                                FollowListPage(followList: profile.following,),
                              );
                            },
                          ),
                        ),
                        ProfileBannerText(
                          count: profile.followers.length.toString(),
                          text: AppLocalizations.of(context)!.translate("followers"),
                          onTap: () async {
                            await UsefulMethods().navigatorPushMethod(
                              context,
                              FollowListPage(followList: profile.followers,),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          MiniButton(
            onTap: followAction,
            color: follow ? ColorBank().info : ColorBank().white,
            iconPath: follow ? ImageConstant().followedIcon : ImageConstant().followIcon,
            borderColor: ColorBank().info,
          ),
        ],
      ),
    );
  }
}
