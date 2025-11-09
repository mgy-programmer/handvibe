import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/firebase/firebase_login.dart';
import 'package:handvibe/model_view/firebase/firebase_social_auth.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/close_button.dart';
import 'package:handvibe/view/atom/hobi_text_button.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/molecule/button_with_icon.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/page/base_screen.dart';
import 'package:handvibe/view/page/login_pages/forgot_password.dart';
import 'package:handvibe/view/page/login_pages/signup_page.dart';
import 'package:handvibe/view/template/warning_dialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";
  Progressing progressing = Progressing.idle;
  bool processCheck = false;
  bool hidePassword = true;

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  getEmail() async {
    Future.delayed(const Duration(milliseconds: 50));
    email = await SharedPreferencesMethods().getUserEmail();
    processCheck = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: ColorBank().background,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 50),
              right: ScreenSizeUtil().getCalculateWith(context, 20),
            ),
            child: Align(
              alignment: Alignment(1, -1),
              child: BtnClose(),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: ScreenSizeUtil().getCalculateWith(context, 250),
              height: ScreenSizeUtil().getCalculateHeight(context, 250),
              padding: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 50),
              ),
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 20),
                left: ScreenSizeUtil().getCalculateWith(context, 20),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.translate("welcome_back"),
                style: TextFont().ralewayBoldMethod(40, ColorBank().black, context),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
                    top: ScreenSizeUtil().getCalculateHeight(context, 20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate("sign_in_account"),
                    style: TextFont().ralewayBoldMethod(24, ColorBank().mainText, context),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                  ),
                  child: InputText(
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.translate("enter_email"),
                    hintStyleFont: 14,
                    hintColor: ColorBank().hinTextColor,
                    inputType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                InputText(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.translate("enter_password"),
                  onChanged: (value) {
                    password = value;
                  },
                  hintStyleFont: 14,
                  hintColor: ColorBank().hinTextColor,
                  isPassword: hidePassword,
                  icon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: SvgPicture.asset(
                      hidePassword ? ImageConstant().hiddenIconPassive : ImageConstant().hiddenIconActive,
                      width: ScreenSizeUtil().getCalculateWith(context, 24),
                      height: ScreenSizeUtil().getCalculateWith(context, 24),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment(1, 0),
                  child: HobiTextButton(
                    text: AppLocalizations.of(context)!.translate("forgetting_password"),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => ForgotPassword(),
                      );
                    },
                    textColor: ColorBank().mainText,
                    textFont: 18,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenSizeUtil().getCalculateHeight(context, 50),
                      ),
                      child: HobiButton(
                        text: AppLocalizations.of(context)!.translate("sign_in"),
                        backgroundColor: ColorBank().primary,
                        textColor: ColorBank().white,
                        borderRadius: 15,
                        onTap: () async {
                          setState(() {
                            progressing = Progressing.busy;
                          });
                          if (email != "" && password != "") {
                            if (UsefulMethods().emailCheck(email)) {
                              Map<String, dynamic> result = await FirebaseLogin().signIn(email: email, password: password);
                              debugPrint("####### ${result.toString()} ######");
                              if (result["success"] != "") {
                                if (context.mounted) {
                                  UsefulMethods().navigatorPushAndNeverComeBackMethod(
                                    context,
                                    BaseScreen(
                                      myId: result["myId"],
                                    ),
                                  );
                                }
                              } else if (result["verify"] == false) {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => WarningDialog(
                                      dialogTitle: AppLocalizations.of(context)!.translate("error"),
                                      content: AppLocalizations.of(context)!.translate("email_not_verified"),
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => WarningDialog(
                                      dialogTitle: AppLocalizations.of(context)!.translate("error"),
                                      content: AppLocalizations.of(context)!.translate("general_error_message"),
                                    ),
                                  );
                                }
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return WarningDialog(
                                    dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                    content: AppLocalizations.of(context)!.translate("email_not_suitable"),
                                  );
                                },
                              );
                            }
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => WarningDialog(
                                dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                content: AppLocalizations.of(context)!.translate("fill_input"),
                              ),
                            );
                          }
                          setState(() {
                            progressing = Progressing.idle;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenSizeUtil().getCalculateHeight(context, 50),
                      ),
                      child: HobiButton(
                        text: AppLocalizations.of(context)!.translate("sign_up"),
                        backgroundColor: ColorBank().primary,
                        textColor: ColorBank().white,
                        borderRadius: 15,
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SignupPage(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenSizeUtil().getCalculateHeight(context, 20),
                    bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate("continue_with"),
                    style: TextFont().ralewayRegularMethod(
                      ScreenSizeUtil().calculateFontSize(context, 25),
                      ColorBank().black,
                      context,
                    ),
                  ),
                ),
                ButtonWithIcon(
                  iconPath: ImageConstant().googleIcon,
                  text: AppLocalizations.of(context)!.translate("sign_in_with_google"),
                  onTap: ()async{
                    setState(() {
                      progressing = Progressing.busy;
                    });
                    await FirebaseSocialAuth().signInWithGoogle(context);
                    setState(() {
                      progressing = Progressing.idle;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
