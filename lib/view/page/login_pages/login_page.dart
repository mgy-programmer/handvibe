import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/atom/close_button.dart';
import 'package:handvibe/view/molecule/text_with_go_icon.dart';
import 'package:handvibe/view/page/login_pages/sign_in_page.dart';
import 'package:handvibe/view/page/login_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: ColorBank().white,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 70),
              right: ScreenSizeUtil().getCalculateWith(context, 20),
            ),
            child: Align(
              alignment: Alignment(1, -1),
              child: BtnClose(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child:
            Center(
              child: Container(
                padding: EdgeInsets.all(
                  ScreenSizeUtil().getCalculateWith(context, 10),
                ),
                decoration: BoxDecoration(
                  color: ColorBank().primary.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(360),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: SvgPicture.asset(
                    ImageConstant().logoSVG,
                    width: ScreenSizeUtil().getCalculateWith(context, 250),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              margin: EdgeInsets.only(
                bottom: ScreenSizeUtil().getCalculateHeight(context, 50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SignupPage(),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      width: ScreenSizeUtil().getCalculateWith(context, 335),
                      height: ScreenSizeUtil().getCalculateHeight(context, 60),
                      decoration: BoxDecoration(
                        color: ColorBank().primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate("lets_get_start"),
                          style: TextFont().ralewayBoldMethod(ScreenSizeUtil().getCalculateWith(context, 30), ColorBank().white, context),
                        ),
                      ),
                    ),
                  ),
                  TextWithGoIcon(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SignInPage(),
                        isScrollControlled: true,
                      );
                    },
                    text: AppLocalizations.of(context)!.translate("already_have_account"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
