import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';

class QuestionDialog extends StatelessWidget {
  final String content;
  final Function() yesMethod;
  final Function()? noMethod;
  final Progressing progressing;

  const QuestionDialog({super.key, required this.content, required this.yesMethod, this.noMethod, required this.progressing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().black.withValues(alpha: .6),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: ColorBank().white,
            borderRadius: BorderRadius.circular(27),
          ),
          width: ScreenSizeUtil().getCalculateWith(context, 350),
          padding: EdgeInsets.only(
            bottom: ScreenSizeUtil().getCalculateHeight(context, 30),
            top: ScreenSizeUtil().getCalculateHeight(context, 30),
            left: ScreenSizeUtil().getCalculateWith(context, 10),
            right: ScreenSizeUtil().getCalculateWith(context, 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(ImageConstant().warningLarge),
              Text(
                progressing == Progressing.idle ? content : AppLocalizations.of(context)!.translate("progressing"),
                style: TextFont().ralewayRegularMethod(
                  16,
                  ColorBank().black,
                  context,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HobiButton(
                      onTap: progressing == Progressing.idle ? yesMethod : () {},
                      text: AppLocalizations.of(context)!.translate("yes"),
                      backgroundColor: progressing == Progressing.idle ? ColorBank().primary : ColorBank().primary.withValues(alpha: .4),
                      textColor: ColorBank().white,
                      borderColor: progressing == Progressing.idle ? ColorBank().primary : ColorBank().primary.withValues(alpha: .4),
                      width: 100,
                    ),
                    HobiButton(
                      onTap: progressing == Progressing.idle ? () => noMethod ?? Navigator.pop(context) : () {},
                      text: AppLocalizations.of(context)!.translate("no"),
                      backgroundColor: ColorBank().white,
                      textColor: ColorBank().red,
                      borderColor: progressing == Progressing.idle ? ColorBank().red : ColorBank().red.withValues(alpha: .4),
                      width: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}