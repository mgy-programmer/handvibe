import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class ButtonWithIcon extends StatelessWidget {
  final String iconPath;
  final String text;
  final Function() onTap;
  final double iconSize;
  const ButtonWithIcon({super.key, required this.iconPath, required this.text, required this.onTap, this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenSizeUtil().getCalculateWith(context, 250),
        padding: EdgeInsets.only(
          top: ScreenSizeUtil().getCalculateHeight(context, 5),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 10),
        ),
        decoration: BoxDecoration(
          color: ColorBank().white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorBank().black.withValues(alpha: 0.3))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: ScreenSizeUtil().getCalculateWith(context, iconSize),
              height: ScreenSizeUtil().getCalculateWith(context, iconSize),
            ),
            Container(
              padding: EdgeInsets.only(
                left: ScreenSizeUtil().getCalculateWith(context, 5),
                right: ScreenSizeUtil().getCalculateWith(context, 5),
              ),
              child: Text(
                text,
                style: TextFont().ralewayRegularMethod(16, ColorBank().black, context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
