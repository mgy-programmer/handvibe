import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/atom/go_button.dart';

class MainPageProductTitle extends StatelessWidget {
  final Function() onTapMore;
  final String title;
  final double fonSize;

  const MainPageProductTitle({super.key, required this.onTapMore, required this.title, this.fonSize = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMore,
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextFont().ralewayRegularMethod(fonSize, ColorBank().black, context),
            ),
            GoButton(
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
