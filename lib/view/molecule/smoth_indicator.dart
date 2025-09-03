import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class SmoothIndicator extends StatelessWidget {
  final int scrollingIndex;
  final int index;
  const SmoothIndicator({super.key, required this.scrollingIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    return  AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: ScreenSizeUtil().getCalculateWith(context, 10),
      width: scrollingIndex == index ? ScreenSizeUtil().getCalculateWith(context, 20) : ScreenSizeUtil().getCalculateWith(context, 10),
      decoration: BoxDecoration(
        color: scrollingIndex == index ? ColorBank().primary : ColorBank().primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
