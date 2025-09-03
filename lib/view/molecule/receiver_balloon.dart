import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/profile_image.dart';

class ReceiverBalloon extends StatelessWidget {
  final ProfileModel profileModel;
  final ChatModel chatModel;

  const ReceiverBalloon({super.key, required this.profileModel, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 15),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: ProfileImage(
              profileImagePath: profileModel.profileImagePath,
              onProfileImageTap: () {},
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
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
                    bottomRight: Radius.circular(15),
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
          ),
        ],
      ),
    );
  }
}