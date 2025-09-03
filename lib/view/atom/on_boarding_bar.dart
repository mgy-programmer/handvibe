import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/atom/hobi_text_button.dart';
import 'package:handvibe/view/molecule/smoth_indicator.dart';

class OnBoardingBar extends StatelessWidget {
  final bool prevStatus;
  final String leftButtonText;
  final String rightButtonText;
  final int scrollingIndex;
  final Function()? leftButtonFunction;
  final Function() rightButtonFunction;

  const OnBoardingBar(
      {super.key,
      required this.prevStatus,
      required this.leftButtonText,
      required this.rightButtonText,
      required this.scrollingIndex,
      this.leftButtonFunction,
      required this.rightButtonFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSizeUtil().getCalculateWith(context, 340),
      height: ScreenSizeUtil().getCalculateHeight(context, 50),
      margin: EdgeInsets.only(
        bottom: ScreenSizeUtil().getCalculateHeight(context, 30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HobiTextButton(
            text: leftButtonText,
            onTap: leftButtonFunction ?? () {},
            textColor: prevStatus ? ColorBank().primary : ColorBank().white,
            textFont: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              3,
              (index) => SmoothIndicator(
                scrollingIndex: scrollingIndex,
                index: index,
              ),
            ),
          ),
          HobiTextButton(
            text: rightButtonText,
            onTap: rightButtonFunction,
            textColor: ColorBank().primary,
            textFont: 18,
          ),
        ],
      ),
    );
  }
}
