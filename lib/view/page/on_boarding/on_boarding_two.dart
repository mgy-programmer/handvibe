import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/on_boarding_bar.dart';
import 'package:handvibe/view/atom/title_content.dart';
import 'package:handvibe/view/page/on_boarding/on_boarding_three.dart';

class OnBoardingTwo extends StatelessWidget {
  final int scrollingIndex;

  const OnBoardingTwo({super.key, required this.scrollingIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageConstant().chatIllustration),
                TitleContent(
                  title: AppLocalizations.of(context)!.translate("on_boarding_two_title"),
                  content: AppLocalizations.of(context)!.translate("on_boarding_two_content"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: OnBoardingBar(
              prevStatus: true,
              leftButtonText: AppLocalizations.of(context)!.translate("prev"),
              rightButtonText: AppLocalizations.of(context)!.translate("next"),
              scrollingIndex: scrollingIndex,
              rightButtonFunction: () {
                UsefulMethods().navigatorPushMethod(context, OnBoardingThree(scrollingIndex: 2));
              },
              leftButtonFunction: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
