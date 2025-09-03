import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/provider/chat_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/molecule/lottie_no_content.dart';
import 'package:handvibe/view/organism/chat_card.dart';
import 'package:handvibe/view/page/chat_pages/archived_chat.dart';
import 'package:handvibe/view/page/chat_pages/chat_page.dart';
import 'package:handvibe/view/template/question_dialog.dart';
import 'package:provider/provider.dart';

class ChatHistory extends StatefulWidget {
  final ProfileModel myProfile;

  const ChatHistory({super.key, required this.myProfile});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  String selectedChat = "";
  Progressing progressing = Progressing.idle;
  int limit = 20;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    Provider.of<ChatProvider>(context, listen: false).getChatHistory(context, widget.myProfile.profileId, limit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          debugPrint("Girdi");
          limit += 10;
          Provider.of<ChatProvider>(context, listen: false).getChatHistory(context, widget.myProfile.profileId, limit);
        }
      });
    setState(() {});
  }

  deleteFirebase(String uid, String receiverId) async {
    await FirebaseChat().deleteChatHistory(uid, receiverId);
    if (mounted) {
      limit = 20;
      Provider.of<ChatProvider>(context, listen: false).getChatHistory(context, widget.myProfile.profileId, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, UserProvider>(builder: (context, chatProvider, userProvider, widgets) {
      return Column(
        children: [
          chatProvider.archivedChatHistoryProfile.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    UsefulMethods().navigatorPushMethod(context, ArchivedChat(myProfile: widget.myProfile));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: ScreenSizeUtil().getCalculateHeight(context, 10),
                    ),
                    padding: EdgeInsets.only(
                      top: ScreenSizeUtil().getCalculateHeight(context, 10),
                      bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                    ),
                    decoration: BoxDecoration(
                      color: ColorBank().background,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("archived_message"),
                        style: TextFont().ralewayRegularMethod(18, ColorBank().hinTextColor, context),
                      ),
                    ),
                  ),
                )
              : Container(),
          Container(
            height: ScreenSizeUtil().getCalculateHeight(context, 600),
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 10),
            ),
            child: chatProvider.progressing == Progressing.idle
                ? chatProvider.chatHistoryProfile.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        itemCount: chatProvider.chatHistoryProfile.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              color: ColorBank().info,
                              child: Icon(Icons.archive, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              color: ColorBank().red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => QuestionDialog(
                                    content: AppLocalizations.of(context)!.translate("are_you_sure"),
                                    yesMethod: () async {
                                      await deleteFirebase(
                                          widget.myProfile.profileId, chatProvider.chatHistoryProfile[index].chatHistoryModel.receiverUid);
                                      if (context.mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    progressing: progressing,
                                  ),
                                );
                              } else if (direction == DismissDirection.startToEnd) {
                                ChatHistoryModel chatHistoryModel = chatProvider.chatHistoryProfile[index].chatHistoryModel;
                                chatHistoryModel.isArchived = true;
                                await FirebaseChat().updateChatHistory(chatHistoryModel, widget.myProfile.profileId);
                                fillData();
                              }
                              return false;
                            },
                            child: ChatCard(
                              chatModel: chatProvider.chatHistoryProfile[index].chatHistoryModel,
                              profileModel: chatProvider.chatHistoryProfile[index].profileModel,
                              onTap: () async {
                                if (chatProvider.chatHistoryProfile[index].profileModel.profileId != "") {
                                  await UsefulMethods().navigatorPushMethod(
                                    context,
                                    ChatPage(
                                      receiverProfile: chatProvider.chatHistoryProfile[index].profileModel,
                                      myProfile: userProvider.myProfile!,
                                      chatHistoryModel: chatProvider.chatHistoryProfile[index].chatHistoryModel,
                                    ),
                                  );
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => QuestionDialog(
                                      content: AppLocalizations.of(context)!.translate("no_profile_message"),
                                      yesMethod: () async {
                                        await deleteFirebase(
                                            widget.myProfile.profileId, chatProvider.chatHistoryProfile[index].chatHistoryModel.receiverUid);
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      progressing: progressing,
                                    ),
                                  );
                                }
                                if (context.mounted) {
                                  limit = 20;
                                  Provider.of<ChatProvider>(context, listen: false).getChatHistory(context, widget.myProfile.profileId, limit);
                                }
                              },
                            ),
                          );
                        },
                      )
                    : LottieNoContent(
                        lottiePath: ImageConstant().noMessageImage,
                        text: AppLocalizations.of(context)!.translate("no_message"),
                      )
                : const Center(
                    child: LoadingWidget(),
                  ),
          ),
        ],
      );
    });
  }
}
