import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class HobiOptions extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double hintFont;
  final double margin;
  final double width;
  const HobiOptions({super.key, required this.text, required this.onTap, required this.hintFont, this.margin = 20, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, margin),
          right: ScreenSizeUtil().getCalculateWith(context, margin),
        ),
        padding: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 10),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        ),
        decoration: BoxDecoration(
          color: ColorBank().white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                right: ScreenSizeUtil().getCalculateWith(context, 10),
                left: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              child: SvgPicture.asset(
                ImageConstant().arrowDownIcon,
                width: ScreenSizeUtil().getCalculateWith(context, 10),
                height: ScreenSizeUtil().getCalculateWith(context, 10),
                colorFilter: ColorFilter.mode(ColorBank().hinTextColor, BlendMode.srcIn),
              ),
            ),
            Text(
              text,
              style: TextFont().ralewayRegularMethod(hintFont, ColorBank().hinTextColor, context),
            ),
          ],
        ),
      ),
    );
  }
}
