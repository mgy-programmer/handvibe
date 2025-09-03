import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/provider/chat_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/molecule/lottie_no_content.dart';
import 'package:handvibe/view/organism/chat_card.dart';
import 'package:handvibe/view/page/chat_pages/chat_page.dart';
import 'package:handvibe/view/template/question_dialog.dart';
import 'package:provider/provider.dart';

class ArchivedChat extends StatefulWidget {
  final ProfileModel myProfile;

  const ArchivedChat({super.key, required this.myProfile});

  @override
  State<ArchivedChat> createState() => _ArchivedChatState();
}

class _ArchivedChatState extends State<ArchivedChat> {
  Progressing progressing = Progressing.idle;

  fillData() {
    Provider.of<ChatProvider>(context, listen: false).getChatHistory(context, widget.myProfile.profileId, 10);
  }

  deleteFirebase(String uid, String receiverId) async {
    await FirebaseChat().deleteChatHistory(uid, receiverId);
    fillData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("archived_message"),
          style: TextFont().ralewayRegularMethod(18, ColorBank().secondaryText, context),
        ),
      ),
      body: Consumer<ChatProvider>(builder: (context, chatProvider, widgets) {
        return chatProvider.progressing == Progressing.idle
            ? chatProvider.archivedChatHistoryProfile.isNotEmpty
                ? ListView.builder(
                    itemCount: chatProvider.archivedChatHistoryProfile.length,
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
                                      widget.myProfile.profileId, chatProvider.archivedChatHistoryProfile[index].chatHistoryModel.receiverUid);
                                  if (context.mounted) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                progressing: progressing,
                              ),
                            );
                          } else if (direction == DismissDirection.startToEnd) {
                            ChatHistoryModel chatHistoryModel = chatProvider.archivedChatHistoryProfile[index].chatHistoryModel;
                            chatHistoryModel.isArchived = false;
                            await FirebaseChat().updateChatHistory(chatHistoryModel, widget.myProfile.profileId);
                            fillData();
                          }
                          return false;
                        },
                        child: ChatCard(
                          chatModel: chatProvider.archivedChatHistoryProfile[index].chatHistoryModel,
                          profileModel: chatProvider.archivedChatHistoryProfile[index].profileModel,
                          onTap: () async {
                            if (chatProvider.archivedChatHistoryProfile[index].profileModel.profileId != "") {
                              await UsefulMethods().navigatorPushMethod(
                                context,
                                ChatPage(
                                  receiverProfile: chatProvider.archivedChatHistoryProfile[index].profileModel,
                                  myProfile: widget.myProfile,
                                  chatHistoryModel: chatProvider.archivedChatHistoryProfile[index].chatHistoryModel,
                                ),
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => QuestionDialog(
                                  content: AppLocalizations.of(context)!.translate("no_profile_message"),
                                  yesMethod: () async {
                                    await deleteFirebase(
                                        widget.myProfile.profileId, chatProvider.archivedChatHistoryProfile[index].chatHistoryModel.receiverUid);
                                    fillData();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  progressing: progressing,
                                ),
                              );
                            }
                            if (context.mounted) {
                              fillData();
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
            : LoadingWidget();
      }),
    );
  }
}
