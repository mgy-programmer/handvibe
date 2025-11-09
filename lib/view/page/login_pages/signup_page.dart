import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/firebase/firebase_login.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/close_button.dart';
import 'package:handvibe/view/atom/give_break.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/atom/password_check_option.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/molecule/info_text.dart';
import 'package:handvibe/view/page/login_pages/sign_in_page.dart';
import 'package:handvibe/view/template/verify_dialog.dart';
import 'package:handvibe/view/template/warning_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool checkEmail = true;
  ScrollController scrollController = ScrollController();
  bool hasLower = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool has6digit = false;
  bool checkPassword = false;

  String email = "";
  String password = "";
  String passwordVerify = "";
  String name = "";
  String surname = "";
  late FocusNode _focusNode;
  bool hidePassword = true;

  Progressing progressing = Progressing.idle;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Keyboard is open
      debugPrint('Keyboard is open');
    } else {
      _scrollToTop();
      debugPrint('Keyboard is closed');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void validatePassword(String value) {
    hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    hasLower = RegExp(r'[a-z]').hasMatch(value);
    hasNumber = RegExp(r'[0-9]').hasMatch(value);
    has6digit = value.length >= 6;

    if (hasUpper && hasLower && hasNumber && has6digit) {
      checkPassword = true;
    } else {
      checkPassword = false;
    }
    if (value.isEmpty) {
      hasNumber = hasUpper = hasLower = has6digit = checkPassword = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorBank().background,
      ),
      child: Stack(
        children: [
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
                AppLocalizations.of(context)!.translate("create_account"),
                style: TextFont().ralewayBoldMethod(40, ColorBank().black, context),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            alignment: Alignment(1, -1),
            margin: EdgeInsets.only(
              right: ScreenSizeUtil().getCalculateWith(context, 15),
              top: ScreenSizeUtil().getCalculateHeight(context, 50),
            ),
            child: BtnClose(),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenSizeUtil().getCalculateHeight(context, 50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputText(
                      controller: emailController,
                      hintText: AppLocalizations.of(context)!.translate("enter_email"),
                      hintStyleFont: 14,
                      hintColor: ColorBank().hinTextColor,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    GiveBreak(),
                    InputText(
                      controller: passwordController,
                      hintText: AppLocalizations.of(context)!.translate("enter_password"),
                      hintStyleFont: 14,
                      hintColor: ColorBank().hinTextColor,
                      onChanged: (value) {
                        password = value;
                        validatePassword(password);
                      },
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
                    password != "" && !checkPassword
                        ? Column(
                            children: [
                              PasswordCheckOption(check: hasLower, text: AppLocalizations.of(context)!.translate("one_lower_letter")),
                              PasswordCheckOption(check: hasUpper, text: AppLocalizations.of(context)!.translate("one_upper_letter")),
                              PasswordCheckOption(check: hasNumber, text: AppLocalizations.of(context)!.translate("one_number")),
                              PasswordCheckOption(check: has6digit, text: AppLocalizations.of(context)!.translate("eight_digit")),
                            ],
                          )
                        : Container(),
                    GiveBreak(),
                    InputText(
                      controller: passwordVerifyController,
                      hintText: AppLocalizations.of(context)!.translate("password_verify"),
                      hintStyleFont: 14,
                      hintColor: ColorBank().hinTextColor,
                      onChanged: (value) {
                        passwordVerify = value;
                      },
                      isPassword: hidePassword,
                    ),
                    GiveBreak(),
                    Container(
                      width: ScreenSizeUtil().getCalculateWith(context, 358),
                      margin: EdgeInsets.only(
                        left: ScreenSizeUtil().getCalculateWith(context, 30),
                        right: ScreenSizeUtil().getCalculateWith(context, 30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InputText(
                            controller: nameController,
                            hintText: AppLocalizations.of(context)!.translate("name"),
                            hintStyleFont: 14,
                            hintColor: ColorBank().hinTextColor,
                            width: 160,
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                          InputText(
                            controller: surnameController,
                            hintText: AppLocalizations.of(context)!.translate("surname"),
                            hintStyleFont: 14,
                            hintColor: ColorBank().hinTextColor,
                            width: 160,
                            onChanged: (value) {
                              surname = value;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment(0, 0),
                          margin: EdgeInsets.only(
                            top: ScreenSizeUtil().getCalculateHeight(context, 50),
                          ),
                          child: HobiButton(
                            text: AppLocalizations.of(context)!.translate("sign_up"),
                            backgroundColor: ColorBank().primary,
                            textColor: ColorBank().white,
                            borderRadius: 15,
                            onTap: email != "" && password != ""
                                ? () async {
                                    setState(() {
                                      progressing = Progressing.busy;
                                    });
                                    setState(() {
                                      if (UsefulMethods().emailCheck(email)) {
                                        checkEmail = true;
                                      } else {
                                        checkEmail = false;
                                      }
                                    });
                                    if (name != "" && surname != "") {
                                      if (checkEmail) {
                                        if (checkPassword) {
                                          if (password == passwordVerify) {
                                            bool checkFakeMail = await checkFakeMailAddress(email);
                                            if (checkFakeMail) {
                                              String languageCode = "tr";
                                              ReturnValue result = await FirebaseLogin().signUp(
                                                languageCode,
                                                email: email,
                                                password: password,
                                                name: name,
                                                surname: surname,
                                              );
                                              if (result.resultValue) {
                                                if (context.mounted) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => VerifyDialog(
                                                      title: AppLocalizations.of(context)!.translate("successful"),
                                                      content: AppLocalizations.of(context)!.translate("success_register"),
                                                    ),
                                                  );
                                                }
                                                setState(() {});
                                                if (context.mounted) Navigator.pop(context);
                                              } else {
                                                if (context.mounted) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => WarningDialog(
                                                      dialogTitle: AppLocalizations.of(context)!.translate("error"),
                                                      content: "${AppLocalizations.of(context)!.translate("unsuccessful_register")} \n\n${result.desc}",
                                                    ),
                                                  );
                                                }
                                              }
                                            } else {
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return WarningDialog(
                                                      dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                                      content: AppLocalizations.of(context)!.translate("fake_mail_warning"),
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return WarningDialog(
                                                  dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                                  content: AppLocalizations.of(context)!.translate("password_not_match"),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return WarningDialog(
                                                dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                                content: AppLocalizations.of(context)!.translate("not_suitable_password"),
                                              );
                                            },
                                          );
                                        }
                                      }
                                      else{
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
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WarningDialog(
                                            dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                            content: AppLocalizations.of(context)!.translate("fill_input"),
                                          );
                                        },
                                      );
                                    }
                                    setState(() {
                                      progressing = Progressing.idle;
                                    });
                                  }
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => WarningDialog(
                                        dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                        content: AppLocalizations.of(context)!.translate("fill_input"),
                                      ),
                                    );
                                  },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenSizeUtil().getCalculateHeight(context, 50),
                          ),
                          child: HobiButton(
                            text: AppLocalizations.of(context)!.translate("sign_in"),
                            backgroundColor: ColorBank().primary,
                            textColor: ColorBank().white,
                            borderRadius: 15,
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => SignInPage(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, 1),
                      child: GestureDetector(
                        onTap: () async{
                          Uri uri = Uri.parse(ConstUrl().privacyUrl);
                          if (!await launchUrl(uri)) {
                            throw Exception('Could not launch ${uri.path}');
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: ScreenSizeUtil().getCalculateHeight(context, 50),
                            bottom: ScreenSizeUtil().getCalculateHeight(context, 30),
                            left: ScreenSizeUtil().getCalculateWith(context, 10),
                            right: ScreenSizeUtil().getCalculateWith(context, 10),
                          ),
                          child: InfoText(
                            text: AppLocalizations.of(context)!.translate("accept_statement"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          progressing != Progressing.idle?Align(
            alignment: Alignment.center,
            child: Center(
              child: LoadingWidget(),
            ),
          ):Container(),
        ],
      ),
    );
  }

  Future<bool> checkFakeMailAddress(String value) async {
    List fakeMailList = [
      "@ebuthor.com",
      "@gufum.com",
      "@zipcatfish.com",
      "@pirolsnet.com",
      "@sfolkar.com",
      "@zlorkun.com",
      "@gonetor.com",
      "@greencafe24.com",
      "@skygazerhub.com",
      "@bloheyz.com",
      "@tippabble.com",
      "@waterisgone.com",
      "@bloheyz.com",
      "@pelagius.net",
      "@closetab.email",
      "@secretmail.net",
      "@puabook.com",
      "crankymonkey.info",
      "cashbenties.com",
      "@mailto.plus",
      "@fexpost.com",
      "@fexbox.org",
      "@mailbox.in.ua",
      "@rover.info",
      "@chitthi.in",
      "@fextemp.com",
      "@any.pink",
      "@merepost.com",
    ];

    for (var i in fakeMailList) {
      if (value.contains(i)) {
        return false;
      }
    }
    return true;
  }
}
