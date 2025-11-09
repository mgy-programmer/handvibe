import 'package:flutter/material.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
            ),
            child: CircularProgressIndicator(
              color: ColorBank().primary,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.translate("progressing"),
            style: TextFont().ralewayRegularMethod(
              17,
              ColorBank().secondaryText,
              fontWeight: FontWeight.w600,
              context,
            ),
          )
        ],
      ),
    );
  }
}
