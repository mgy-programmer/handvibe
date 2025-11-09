import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class InputChat extends StatelessWidget {
  final TextEditingController commentController;
  final String hintText;
  final Function() send;
  final Function(String) onChanged;
  final String shareText;
  final FocusNode focusNode;

  const InputChat(
      {super.key,
      required this.commentController,
      required this.hintText,
      required this.send,
      required this.shareText,
      required this.focusNode,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSizeUtil().getCalculateWith(context, 350),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: ColorBank().hinTextColor),
        color: ColorBank().white,
      ),
      padding: EdgeInsets.only(
        left: ScreenSizeUtil().getCalculateWith(context, 10),
      ),
      margin: EdgeInsets.only(
        bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: ScreenSizeUtil().getCalculateWith(context, 240),
            padding: EdgeInsets.only(
              right: ScreenSizeUtil().getCalculateWith(context, 10),
            ),
            child: TextFormField(
              controller: commentController,
              onChanged: onChanged,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextFont().ralewayThinMethod(
                  14,
                  ColorBank().hinTextColor,
                  context,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: send,
            child: Container(
              decoration: BoxDecoration(
                color: ColorBank().info,
                borderRadius: BorderRadius.circular(360),
              ),
              padding: EdgeInsets.all(
                ScreenSizeUtil().getCalculateWith(context, 5),
              ),
              margin: EdgeInsets.only(
                right: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              child: Icon(
                Icons.send,
                color: ColorBank().white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
