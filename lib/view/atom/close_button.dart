import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class BtnClose extends StatelessWidget {
  const BtnClose({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(ScreenSizeUtil().getCalculateWith(context, 5)),
        decoration: BoxDecoration(
          color: ColorBank().red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.close,
          color: ColorBank().white,
        ),
      ),
    );
  }
}
