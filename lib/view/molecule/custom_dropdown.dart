import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class CustomDropdown extends StatelessWidget {
  final int openedOption;
  final Function() onTap;
  final String question;
  final String answer;
  final int index;

  const CustomDropdown({super.key, required this.openedOption, required this.onTap, required this.question, required this.answer, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorBank().background,
            ),
          ),
        ),
        padding: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 10),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: ScreenSizeUtil().getCalculateWith(context, 300),
                    child: Text(
                      question,
                      style: TextFont().ralewayRegularMethod(
                        18,
                        ColorBank().secondaryText,
                        fontWeight: FontWeight.w700,
                        context,
                      ),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: openedOption == index ? 1 : 3,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorBank().black,
                  ),
                ),
              ],
            ),
            openedOption == index
                ? Container(
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 10),
              ),
              child: Text(
                answer,
                style: TextFont().ralewayRegularMethod(
                  16,
                  ColorBank().black,
                  fontWeight: FontWeight.w500,
                  context,
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
