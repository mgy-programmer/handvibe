import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class TitleContent extends StatelessWidget {
  final String title;
  final String content;
  const TitleContent({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSizeUtil().getCalculateWith(context, 340),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 20),
            ),
            child: Text(
              title,
              style: TextFont().ralewayBoldMethod(24, ColorBank().black, context),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 20),
            ),
            child: Text(
              content,
              style: TextFont().ralewaySemiBoldMethod(14, ColorBank().onBoardingContent, context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
