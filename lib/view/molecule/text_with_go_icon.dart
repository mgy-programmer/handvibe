import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/atom/go_button.dart';

class TextWithGoIcon extends StatelessWidget {
  final Function() onTap;
  final String text;

  const TextWithGoIcon({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenSizeUtil().getCalculateHeight(context, 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                right: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              child: Text(
                text,
                style: TextFont().ralewayRegularMethod(ScreenSizeUtil().calculateFontSize(context, 20), ColorBank().black, context),
              ),
            ),
            GoButton(onTap: onTap),
          ],
        ),
      ),
    );
  }
}
