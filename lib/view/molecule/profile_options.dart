import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class ProfileOptions extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color color;

  const ProfileOptions({super.key, required this.onTap, required this.text, this.color = const Color(0xFF0084FF)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        padding: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 5),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
          color: ColorBank().white,
        ),
        child: Text(
          text,
          style: TextFont().ralewayBoldMethod(18, color, context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
