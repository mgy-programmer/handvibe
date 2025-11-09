import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class NavOption extends StatelessWidget {
  final String iconActivePath;
  final String iconPassivePath;
  final String optionName;
  final int selectedIndex;
  final int index;
  final Function(int) onTap;

  const NavOption({
    super.key,
    required this.iconActivePath,
    required this.iconPassivePath,
    required this.optionName,
    required this.selectedIndex,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: ScreenSizeUtil().getCalculateHeight(context, 24),
            width: ScreenSizeUtil().getCalculateHeight(context, 24),
            child: SvgPicture.asset(selectedIndex == index ? iconActivePath : iconPassivePath, fit: BoxFit.fill,),
          ),
          Text(
            optionName,
            style: TextFont().ralewayRegularMethod(12, ColorBank().white, context),
          ),
        ],
      ),
    );
  }
}
