import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class NavIcon extends StatelessWidget {
  final Function() onTap;
  final String text;
  final int index;
  final int selectedIndex;
  final String iconActivePath;
  final String iconPassivePath;
  final bool isSeen;
  const NavIcon({super.key, required this.onTap, required this.text, required this.index, required this.selectedIndex, required this.iconActivePath, required this.iconPassivePath, required this.isSeen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: ScreenSizeUtil().getCalculateHeight(context, 24),
            width: ScreenSizeUtil().getCalculateHeight(context, 24),
            child: Stack(
              children: [
                SvgPicture.asset(
                  selectedIndex == 1 ? iconActivePath : iconPassivePath,
                  fit: BoxFit.fill,
                  width: ScreenSizeUtil().getCalculateWith(context, 32),
                ),
                isSeen
                    ? Container()
                    : Align(
                  alignment: const Alignment(1, -1),
                  child: Icon(
                    Icons.lens,
                    color: ColorBank().red,
                    size: ScreenSizeUtil().getCalculateWith(context, 10),
                  ),
                ),
              ],
            ),
          ),
          Text(
            text,
            style: TextFont().ralewayRegularMethod(12, ColorBank().white, context),
          ),
        ],
      ),
    );
  }
}
