import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class LoginTitle extends StatelessWidget {
  final String text;
  const LoginTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: ScreenSizeUtil().getCalculateWith(context, 240),
        padding: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 20),
        ),
        child: Text(
          text,
          style: TextFont().ralewayBoldMethod(ScreenSizeUtil().calculateFontSize(context, 48), ColorBank().black, context),
          textAlign: TextAlign.left,
        ),
      );
  }
}
