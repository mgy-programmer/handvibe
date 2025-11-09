import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';

class WarningDialog extends StatelessWidget {
  final String dialogTitle;
  final String content;

  const WarningDialog({super.key, required this.dialogTitle, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: SvgPicture.asset(ImageConstant().warningLarge),
      iconPadding: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 20),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
      ),
      title: Text(
        dialogTitle,
        style: TextFont().ralewayRegularMethod(
          20,
          ColorBank().black,
          fontWeight: FontWeight.w700,
          context,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextFont().ralewayRegularMethod(
          17,
          ColorBank().black,
          context,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        HobiButton(
          onTap: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.translate("ok"),
          backgroundColor: ColorBank().primary,
          textColor: ColorBank().white,
        ),
      ],
    );
  }
}