import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class ProfileImageAsset extends StatelessWidget {
  final String profileImagePath;
  final double marginLeft;
  final double marginRight;
  final double width;
  final double height;
  final bool isShadow;
  final Function()? onProfileImageTap;

  const ProfileImageAsset({
    super.key,
    required this.profileImagePath,
    required this.marginLeft,
    required this.marginRight,
    required this.width,
    required this.height,
    required this.isShadow,
    this.onProfileImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProfileImageTap,
      child: Container(
        width: ScreenSizeUtil().getCalculateWith(context, width),
        height: ScreenSizeUtil().getCalculateWith(context, height),
        margin: EdgeInsets.only(
          right: ScreenSizeUtil().getCalculateWith(context, marginRight),
          left: ScreenSizeUtil().getCalculateWith(context, marginLeft),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(180),
          boxShadow: isShadow
              ? [
                  BoxShadow(
                    color: ColorBank().black.withValues(alpha: .5),
                    blurRadius: 150,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(360),
          child: Image.asset(
            profileImagePath,
            fit: BoxFit.fill,
            errorBuilder: (context, obj, stacktrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  border: Border.all(color: ColorBank().white),
                  color: ColorBank().white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Image.asset(
                    ImageConstant().logo,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
