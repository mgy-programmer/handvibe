import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/firebase/firebase_login.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/atom/close_button.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/template/verify_dialog.dart';
import 'package:handvibe/view/template/warning_dialog.dart';
import 'package:translator/translator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mailController = TextEditingController();
  String email = "";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 50),
                right: ScreenSizeUtil().getCalculateWith(context, 15),
              ),
              child: BtnClose(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: ScreenSizeUtil().getCalculateWith(context, 15),
                right: ScreenSizeUtil().getCalculateWith(context, 15),
              ),
              margin: EdgeInsets.only(
                bottom: ScreenSizeUtil().getCalculateHeight(context, 100),
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: ScreenSizeUtil().getCalculateHeight(context, 50),
                    ),
                    child: SvgPicture.asset(ImageConstant().forgotPasswordImage),
                  ),
                  InputText(
                    controller: mailController,
                    hintText: AppLocalizations.of(context)!.translate("enter_email"),
                    onChanged: (value) {
                      email = value;
                    },
                    hintStyleFont: 14,
                    hintColor: ColorBank().black.withValues(alpha: 0.5),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenSizeUtil().getCalculateHeight(context, 20),
                    ),
                    alignment: Alignment.center,
                    child: HobiButton(
                      onTap: () async {
                        if (email != "") {
                          errorMessage = await FirebaseLogin().resetPassword(email);
                          if(errorMessage == ""){
                            if (context.mounted) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return VerifyDialog(
                                    title: AppLocalizations.of(context)!.translate("verify_content"),
                                    content: "",
                                  );
                                },
                              );
                            }
                            if(context.mounted){
                              Navigator.pop(context);
                            }
                          }
                          else{
                            if (context.mounted) {
                              final translator = GoogleTranslator();
                              String translatedText = "";
                              await translator
                                  .translate(errorMessage.split("]").last,
                                  to: AppLocalizations.of(context)!.locale.languageCode)
                                  .then((value) {
                                setState(() {
                                  translatedText = value.text;
                                });
                              });
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => WarningDialog(
                                    dialogTitle: AppLocalizations.of(context)!.translate("error"),
                                    content: "${AppLocalizations.of(context)!.translate("general_error_message")}\n\n$translatedText",
                                  ),
                                );
                              }
                            }
                          }
                        } else {
                          if (context.mounted) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return WarningDialog(
                                  dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                  content: AppLocalizations.of(context)!.translate("fill_input"),
                                );
                              },
                            );
                          }
                        }
                      },
                      text: AppLocalizations.of(context)!.translate("send"),
                      backgroundColor: ColorBank().primary,
                      textColor: ColorBank().white,
                      borderRadius: 15,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
