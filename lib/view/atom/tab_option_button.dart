import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class TabOptionButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final int index;
  final int selectedIndex;

  const TabOptionButton({super.key, required this.onTap, required this.text, required this.index, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: ScreenSizeUtil().getCalculateHeight(context, 50),
        decoration: BoxDecoration(
          color: index == selectedIndex ? ColorBank().primary : ColorBank().white,
        ),
        child: Center(
          child: Text(
            text,
            style: index == selectedIndex
                ? TextFont().ralewayBoldMethod(18, ColorBank().white, context)
                : TextFont().ralewayRegularMethod(18, ColorBank().primary, context),
          ),
        ),
      ),
    );
  }
}
