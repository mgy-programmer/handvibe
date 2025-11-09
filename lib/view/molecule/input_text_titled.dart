import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/atom/input_text.dart';

class InputTextTitled extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double hintFont;
  final String title;
  final bool isPassword;
  final Function(String) onChanged;

  const InputTextTitled({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hintFont,
    required this.title,
    required this.onChanged,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
          ),
          child: Text(
            title,
            style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
          ),
        ),
        InputText(
          controller: controller,
          hintText: hintText,
          onChanged: onChanged,
          hintStyleFont: hintFont,
          isPassword: isPassword,
          hintColor: ColorBank().secondaryText,
        ),
      ],
    );
  }
}
