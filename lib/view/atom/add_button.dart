import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class AddButton extends StatelessWidget {
  final Function() onTap;
  const AddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        margin: EdgeInsets.only(
          bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        ),
        decoration: BoxDecoration(
          color: ColorBank().primary,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(
          Icons.add,
          color: ColorBank().white,
        ),
      ),
    );
  }
}
