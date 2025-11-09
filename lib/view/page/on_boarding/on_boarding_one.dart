import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/on_boarding_bar.dart';
import 'package:handvibe/view/atom/title_content.dart';
import 'package:handvibe/view/page/on_boarding/on_boarding_two.dart';

class OnBoardingOne extends StatelessWidget {
  final int scrollingIndex;

  const OnBoardingOne({super.key, required this.scrollingIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageConstant().sellIllustration),
                TitleContent(
                  title: AppLocalizations.of(context)!.translate("on_boarding_one_title"),
                  content: AppLocalizations.of(context)!.translate("on_boarding_one_content"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: OnBoardingBar(
              prevStatus: false,
              leftButtonText: "",
              rightButtonText: AppLocalizations.of(context)!.translate("next"),
              scrollingIndex: scrollingIndex,
              rightButtonFunction: () {
                UsefulMethods().navigatorPushMethod(context, OnBoardingTwo(scrollingIndex: 1));
              },
            ),
          )
        ],
      ),
    );
  }
}
