import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/page/base_screen.dart';
import 'package:handvibe/view/page/on_boarding/on_boarding_one.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    redirectToOtherPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(ImageConstant().namedLogo),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 20,
              ),
              child: Text(
                "${AppLocalizations.of(context)!.translate("loading")}.....",
                style: TextFont().ralewayRegularMethod(18, ColorBank().white, context),
              ),
            ),
          )
        ],
      ),
    );
  }

  void redirectToOtherPage() async {
    await Future.delayed(Duration(seconds: 3));
    bool firstTime = await SharedPreferencesMethods().getFirstTime();
    if (firstTime) {
      await SharedPreferencesMethods().saveFirstTime(false);
      if(mounted){
        UsefulMethods().navigatorPushMethod(
          context,
          OnBoardingOne(
            scrollingIndex: 0,
          ),
        );
      }
    } else {
      String userId = await SharedPreferencesMethods().getUserID();
      if (mounted) {
        UsefulMethods().navigatorPushMethod(
          context,
          BaseScreen(
            myId: userId,
          ),
        );
      }
    }
  }
}
