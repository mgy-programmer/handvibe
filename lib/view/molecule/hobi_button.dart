import 'package:flutter/material.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class HobiButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function() onTap;
  final Color textColor;
  final Color borderColor;
  final double textFont;
  final double width;
  final double borderRadius;

  const HobiButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.textColor,
    this.borderColor = const Color(0xFFFFFFFF),
    this.textFont = 20,
    this.width = 150,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          border: Border.all(color: borderColor)
        ),
        width: ScreenSizeUtil().getCalculateWith(context, width),
        padding: EdgeInsets.only(
          top: ScreenSizeUtil().getCalculateHeight(context, 5),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        child: Text(
          text,
          style: TextFont().ralewayBoldMethod(textFont, textColor, context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
