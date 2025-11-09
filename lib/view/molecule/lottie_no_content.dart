import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:lottie/lottie.dart';

class LottieNoContent extends StatelessWidget {
  final String lottiePath;
  final String text;
  final double lottieScale;

  const LottieNoContent({super.key, required this.lottiePath, required this.text, this.lottieScale = 400});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: ScreenSizeUtil().getCalculateWith(context, lottieScale),
              height: ScreenSizeUtil().getCalculateWith(context, lottieScale),
              child: Lottie.asset(lottiePath),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 10),
              ),
              child: Text(
                text,
                style: TextFont().ralewayRegularMethod(
                  18,
                  ColorBank().black,
                  fontWeight: FontWeight.w600,
                  context,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}