import 'package:flutter/material.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class GiveBreak extends StatelessWidget {
  final double height;
  const GiveBreak({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSizeUtil().getCalculateHeight(context, height),
    );
  }
}
