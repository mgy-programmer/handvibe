import 'package:flutter/material.dart';
import 'package:handvibe/model_view/firebase/firebase_login.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/template/warning_dialog.dart';

class ReAuthDialog extends StatefulWidget {
  final String email;
  final Function(bool result) reAuthFunc;

  const ReAuthDialog({super.key, required this.email, required this.reAuthFunc});

  @override
  State<ReAuthDialog> createState() => _ReAuthDialogState();
}

class _ReAuthDialogState extends State<ReAuthDialog> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();

  String password = "";
  String verifyPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().black.withValues(alpha: .4),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: ColorBank().white,
            borderRadius: BorderRadius.circular(27),
          ),
          padding: EdgeInsets.only(
            top: ScreenSizeUtil().getCalculateHeight(context, 20),
            bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
            left: ScreenSizeUtil().getCalculateHeight(context, 10),
            right: ScreenSizeUtil().getCalculateHeight(context, 10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
                ),
                child: InputText(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.translate("password"),
                  onChanged: (value) {
                    password = value;
                  },
                  hintStyleFont: 16,
                  hintColor: ColorBank().hinTextColor,
                  isPassword: true,
                ),
              ),
              InputText(
                controller: passwordVerifyController,
                hintText: AppLocalizations.of(context)!.translate("password_verify"),
                onChanged: (value) {
                  verifyPassword = value;
                },
                hintStyleFont: 16,
                hintColor: ColorBank().hinTextColor,
                isPassword: true,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HobiButton(
                      onTap: () => Navigator.pop(context),
                      text: AppLocalizations.of(context)!.translate("cancel"),
                      backgroundColor: ColorBank().primary,
                      textColor: ColorBank().white,
                      width: 100,
                    ),
                    HobiButton(
                      onTap: () async {
                        if (password != "" && verifyPassword != "") {
                          if (password == verifyPassword) {
                            Map<String, dynamic> result = await FirebaseLogin().signIn(email: widget.email, password: password);
                            if (result["success"] != "") {
                              widget.reAuthFunc(true);
                            } else {
                              widget.reAuthFunc(false);
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => WarningDialog(
                                dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                                content: AppLocalizations.of(context)!.translate("password_not_match"),
                              ),
                            );
                          }
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context) => WarningDialog(
                              dialogTitle: AppLocalizations.of(context)!.translate("warning"),
                              content: AppLocalizations.of(context)!.translate("fill_input"),
                            ),
                          );
                        }
                      },
                      text: AppLocalizations.of(context)!.translate("delete"),
                      backgroundColor: ColorBank().red,
                      textColor: ColorBank().white,
                      width: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}