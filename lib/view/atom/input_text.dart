import 'package:flutter/material.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final double hintStyleFont;
  final Color hintColor;
  final bool isPassword;
  final double width;
  final FontWeight fontWeight;
  final bool readOnly;
  final TextInputType inputType;
  final int? maxLength;
  final int? maxLines;
  final Widget? icon;

  const InputText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.hintStyleFont,
    required this.hintColor,
    this.isPassword = false,
    this.width = 358,
    this.fontWeight = FontWeight.w500,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.maxLength,
    this.maxLines,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        left: ScreenSizeUtil().getCalculateWith(context, 20),
        right: ScreenSizeUtil().getCalculateWith(context, 20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword,
        readOnly: readOnly,
        keyboardType: inputType,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontSize: hintStyleFont),
          suffixIcon: icon,
        ),
      ),
    );
  }
}
