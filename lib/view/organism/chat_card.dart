import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/profile_image.dart';

class ChatCard extends StatelessWidget {
  final ChatHistoryModel chatModel;
  final ProfileModel profileModel;
  final Function() onTap;

  const ChatCard({super.key, required this.chatModel,required this.onTap, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorBank().headingText.withValues(alpha: .4),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          "${profileModel.name} ${profileModel.surname}",
          style: TextFont().ralewayRegularMethod(
            16,
            ColorBank().black,
            fontWeight: FontWeight.w400,
            context,
          ),
        ),
        leading: SizedBox(
          width: ScreenSizeUtil().getCalculateWith(context, 60),
          height: ScreenSizeUtil().getCalculateWith(context, 60),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(1, 1),
                child: !chatModel.isSeen && !chatModel.fromMe
                    ? Icon(
                  Icons.circle,
                  color: ColorBank().red,
                  size: 10,
                )
                    : Container(),
              ),
              Align(
                alignment: Alignment.center,
                child: ProfileImage(
                  profileImagePath: profileModel.profileImagePath,
                  onProfileImageTap: onTap,
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          UsefulMethods().dateTimeToTurkishDate(chatModel.lastMessageTime, context),
          style: TextFont().ralewayRegularMethod(
            12,
            ColorBank().hinTextColor,
            fontWeight: FontWeight.w300,
            context,
          ),
        ),
        subtitle: Text(
          chatModel.lastMessage,
          style: TextFont().ralewayRegularMethod(
            14,
            ColorBank().black,
            fontWeight: !chatModel.isSeen && !chatModel.fromMe ? FontWeight.w500 : FontWeight.w300,
            context,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}