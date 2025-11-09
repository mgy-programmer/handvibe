import 'package:flutter/cupertino.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class TextFont {
  ralewayBoldMethod(double size, Color color,  BuildContext context, {bool isUnderline = false, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: "assets/font/Raleway/Raleway-Black.ttf",
      fontSize: ScreenSizeUtil().calculateFontSize(context, size),
      fontWeight: FontWeight.bold,
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  ralewayRegularMethod(double size, Color color, BuildContext context, {bool isUnderline = false, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: "assets/font/Raleway/Raleway-Regular.ttf",
      fontSize: ScreenSizeUtil().calculateFontSize(context, size),
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontWeight: fontWeight,
    );
  }

  ralewayMediumMethod(double size, Color color,  BuildContext context, {bool isUnderline = false, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: "assets/font/Raleway/Raleway-Medium.ttf",
      fontSize: ScreenSizeUtil().calculateFontSize(context, size),
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  ralewaySemiBoldMethod(double size, Color color,  BuildContext context, {bool isUnderline = false, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontFamily: "assets/font/Raleway/Raleway-SemiBold.ttf",
      fontSize: ScreenSizeUtil().calculateFontSize(context, size),
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  ralewayThinMethod(double size, Color color,  BuildContext context, {bool isUnderline = false}) {
    return TextStyle(
      fontFamily: "assets/font/Raleway/Raleway-Thin.ttf",
      fontSize: ScreenSizeUtil().calculateFontSize(context, size),
      color: color,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
