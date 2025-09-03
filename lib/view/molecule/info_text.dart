import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class InfoText extends StatelessWidget {
  final String text;
  const InfoText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(ImageConstant().infoIcon, width: ScreenSizeUtil().getCalculateWith(context, 36),),
          Container(
            width: ScreenSizeUtil().getCalculateWith(context, 300),
            margin: EdgeInsets.only(
              left: ScreenSizeUtil().getCalculateWith(context, 10),
            ),
            child: Text(
              text,
              style: TextFont().ralewayBoldMethod(14, ColorBank().secondaryText, context),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
