import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/chat_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/notification_services.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/input_chat.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/molecule/receiver_balloon.dart';
import 'package:handvibe/view/molecule/sender_balloon.dart';

class ChatPage extends StatefulWidget {
  final ProfileModel receiverProfile;
  final ProfileModel myProfile;
  final ChatHistoryModel? chatHistoryModel;

  const ChatPage({super.key, required this.receiverProfile, required this.myProfile, this.chatHistoryModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController commentController = TextEditingController();
  String message = "";
  ScrollController _scrollController = ScrollController();
  bool first = true;
  ChatModel? lastChat;
  int limit = 10;
  bool isFetching = false; // Prevent multiple fetches during scrolling

  @override
  void initState() {
    updateChatHistory(true, widget.chatHistoryModel);
    _initializeScrollListener();
    super.initState();
  }

  updateChatHistory(bool scrollStatus, ChatHistoryModel? chatModel) async {
    if (chatModel != null) {
      ChatHistoryModel chatHistoryModel = chatModel;
      chatHistoryModel.isSeen = true;
      FirebaseChat().updateChatHistory(chatHistoryModel, widget.myProfile.profileId);
    }
  }

  _initializeScrollListener() {
    _scrollController = ScrollController()
      ..addListener(() async {
        if (_scrollController.position.atEdge && _scrollController.position.pixels == 0 && !isFetching) {
          // User scrolled to the top
          setState(() {
            isFetching = true;
            limit += 10; // Fetch 10 more messages
          });

          // Allow fetching again after a short delay
          await Future.delayed(const Duration(milliseconds: 300));
          setState(() {
            isFetching = false;
          });
        }
      });
  }

  scrollChatToLast() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().background,
      appBar: AppBar(
        title: Text(
          "${widget.receiverProfile.name} ${widget.receiverProfile.surname}".toUpperCase(),
          style: TextFont().ralewayRegularMethod(
            18,
            ColorBank().secondaryText,
            context,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            if (lastChat != null) {
              await updateChatHistory(
                false,
                ChatHistoryModel(lastChat!.receiverUID, lastChat!.fromMe, true, lastChat!.messageContent, lastChat!.sendTime, false),
              );
            }
            if (context.mounted) Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorBank().secondaryText,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 10),
              bottom: ScreenSizeUtil().getCalculateHeight(context, 80),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseChat().getConversationCollectionByReceiverId(widget.myProfile.profileId, widget.receiverProfile.profileId, limit),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }
                switch (asyncSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingWidget();
                  default:
                    final messages = asyncSnapshot.data!.docs.map((doc) => ChatModel.fromSnapshot(doc)).toList();
                    return ListView.builder(
                      reverse: true,
                      // Reverse to show the newest message at the bottom
                      controller: _scrollController,
                      itemCount: messages.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        ChatModel chatModel = messages[index];
                        if (!messages.last.fromMe && first == false && messages.last.sendTime.second == DateTime.now().second) {
                          //UsefulMethods().ringPhone();
                        }
                        first = false;
                        lastChat = messages.last;
                        return chatModel.fromMe
                            ? SenderBalloon(
                                profileModel: widget.myProfile,
                                chatModel: chatModel,
                              )
                            : ReceiverBalloon(
                                profileModel: widget.receiverProfile,
                                chatModel: chatModel,
                              );
                      },
                    );
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: ColorBank().white,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: ScreenSizeUtil().getCalculateHeight(context, 10),
                  horizontal: ScreenSizeUtil().getCalculateWith(context, 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputChat(
                      commentController: commentController,
                      hintText: "",
                      send: () async {
                        final messageText = message.trim();
                        if (messageText.isEmpty) return;
                        commentController.clear();
                        String senderChatId = UsefulMethods().generate32BitKey(widget.myProfile.profileId);
                        await FirebaseChat().sendMessage(
                          ChatModel(senderChatId, widget.myProfile.profileId, widget.receiverProfile.profileId, messageText, DateTime.now(), true),
                          senderChatId,
                        );
                        String receiverChatId = UsefulMethods().generate32BitKey(widget.myProfile.profileId);
                        await FirebaseChat().sendMessage(
                          ChatModel(receiverChatId, widget.receiverProfile.profileId, widget.myProfile.profileId, messageText, DateTime.now(), false),
                          receiverChatId,
                        );
                        if (widget.receiverProfile.deviceToken.isNotEmpty) {
                          String notificationTitle = "";
                          String notificationContent = "";
                          if (context.mounted) {
                            notificationTitle =
                                await AppLocalizations.of(context)!.translateByLanguageCode("new_message", widget.receiverProfile.selectedLanguage);
                            notificationContent = "${widget.myProfile.username} $messageText";
                          }
                          await NotificationServices()
                              .sendFCMNotification(notificationTitle, notificationContent, widget.receiverProfile.deviceToken);
                        }
                        scrollChatToLast();
                      },
                      shareText: AppLocalizations.of(context)!.translate("send"),
                      focusNode: FocusNode(),
                      onChanged: (value) {
                        message = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
