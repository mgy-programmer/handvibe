import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/profile_image.dart';

class SenderBalloon extends StatelessWidget {
  final ProfileModel profileModel;
  final ChatModel chatModel;

  const SenderBalloon({super.key, required this.profileModel, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 15),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: ScreenSizeUtil().getCalculateHeight(context, 30),
              minWidth: ScreenSizeUtil().getCalculateWith(context, 215),
              maxWidth: ScreenSizeUtil().getCalculateWith(context, 215),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ColorBank().white,
                border: Border.all(color: ColorBank().primary),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 6.5),
                bottom: ScreenSizeUtil().getCalculateHeight(context, 6.5),
                right: ScreenSizeUtil().getCalculateWith(context, 8),
                left: ScreenSizeUtil().getCalculateWith(context, 8),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: const Alignment(-1, 0),
                    child: Text(
                      chatModel.messageContent,
                      style: TextFont().ralewayRegularMethod(
                        14,
                        ColorBank().black,
                        context,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 10000,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1, 0),
                    child: Text(
                      UsefulMethods().dateTimeToTurkishDate(chatModel.sendTime, context),
                      style: TextFont().ralewayRegularMethod(
                        12,
                        ColorBank().hinTextColor,
                        context,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(1, 1),
            child: ProfileImage(
              profileImagePath: profileModel.profileImagePath,
              onProfileImageTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}