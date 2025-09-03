import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/on_boarding_bar.dart';
import 'package:handvibe/view/atom/title_content.dart';
import 'package:handvibe/view/page/base_screen.dart';

class OnBoardingThree extends StatelessWidget {
  final int scrollingIndex;
  const OnBoardingThree({super.key, required this.scrollingIndex});


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
                SvgPicture.asset(ImageConstant().managerIllustration),
                TitleContent(
                  title: AppLocalizations.of(context)!.translate("on_boarding_three_title"),
                  content: AppLocalizations.of(context)!.translate("on_boarding_three_content"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: OnBoardingBar(
              prevStatus: true,
              leftButtonText: AppLocalizations.of(context)!.translate("prev"),
              rightButtonText: AppLocalizations.of(context)!.translate("lets_get_start"),
              scrollingIndex: scrollingIndex,
              rightButtonFunction: () {
                UsefulMethods().navigatorPushMethod(context, BaseScreen(myId: ""));
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
