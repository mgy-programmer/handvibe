import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class ProfileImage extends StatelessWidget {
  final String profileImagePath;
  final double marginLeft;
  final double marginRight;
  final double width;
  final double height;
  final bool isShadow;
  final Function()? onProfileImageTap;

  const ProfileImage({
    super.key,
    required this.profileImagePath,
    this.marginLeft = 10,
    this.marginRight = 15,
    this.height = 40,
    this.width = 40,
    this.isShadow = false,
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
          child: Image.network(
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
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
