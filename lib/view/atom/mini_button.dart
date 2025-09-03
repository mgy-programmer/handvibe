import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class MiniButton extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final Color borderColor;
  final String iconPath;
  const MiniButton({super.key, required this.onTap, required this.color, required this.iconPath, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: ScreenSizeUtil().getCalculateHeight(context, 5),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        margin: EdgeInsets.only(
          right: ScreenSizeUtil().getCalculateWith(context, 20),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: ScreenSizeUtil().getCalculateWith(context, 24),
          height: ScreenSizeUtil().getCalculateWith(context, 24),
        ),
      ),
    );
  }
}
