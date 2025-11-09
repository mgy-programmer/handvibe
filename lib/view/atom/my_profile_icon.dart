import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class MyProfileIcon extends StatelessWidget {
  final Function() onTap;
  final String iconPath;
  final double iconSize;
  final double padding;
  const MyProfileIcon({super.key, required this.onTap, required this.iconPath, this.iconSize = 30, this.padding = 5});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ScreenSizeUtil().getCalculateWith(context, padding),
        ),
        decoration: BoxDecoration(
          color: ColorBank().background,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: ScreenSizeUtil().getCalculateWith(context, iconSize),
            height: ScreenSizeUtil().getCalculateWith(context, iconSize),
          ),
        ),
      ),
    );
  }
}
