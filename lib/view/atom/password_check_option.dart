import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class PasswordCheckOption extends StatelessWidget {
  final bool check;
  final String text;

  const PasswordCheckOption({super.key, required this.check, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSizeUtil().getCalculateWith(context, 358),
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 5),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: ScreenSizeUtil().getCalculateWith(context, 5),
            ),
            child: check ? SvgPicture.asset(ImageConstant().checkIcon) : SvgPicture.asset(ImageConstant().warningIcon),
          ),
          Text(
            text,
            style: TextFont().ralewayRegularMethod(
              13,
              ColorBank().black,
              fontWeight: FontWeight.w300,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
