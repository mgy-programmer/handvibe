import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/text_font.dart';

class ProfileBannerText extends StatelessWidget {
  final String count;
  final String text;
  final bool sideBorder;
  final Function() onTap;

  const ProfileBannerText({super.key, required this.count, required this.text, this.sideBorder = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "$count\n",
              style: TextFont().ralewayBoldMethod(
                16,
                ColorBank().black,
                fontWeight: FontWeight.w600,
                context,
              ),
            ),
            TextSpan(
              text: text,
              style: TextFont().ralewayRegularMethod(
                16,
                ColorBank().black,
                fontWeight: FontWeight.w400,
                context,
              ),
            )
          ],
        ),
      ),
    );
  }
}