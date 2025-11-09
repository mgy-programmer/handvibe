import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/chat_history_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/utility/data_constant.dart';
import 'package:handvibe/utility/enum.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatHistoryModel> chats = [];
  List<ChatHistoryProfileModel> chatHistoryProfile = [];
  List<ChatHistoryProfileModel> archivedChatHistoryProfile = [];
  ProfileModel? tempProfile;
  Progressing progressing = Progressing.idle;

  getChatHistory(BuildContext context,String uid, int limit) async {
    progressing = Progressing.busy;
    chatHistoryProfile = [];
    archivedChatHistoryProfile = [];
    chats = await FirebaseChat().getChatHistory(uid, limit);
    for (var i in chats) {
     if(i.isArchived){
       tempProfile = await FireStoreUser().getUserInfo(i.receiverUid);
       if (tempProfile != null && context.mounted) {
         archivedChatHistoryProfile.add(ChatHistoryProfileModel(i, tempProfile??DataConstant().getTempProfile(context)));
       }
     }
     else{
       tempProfile = await FireStoreUser().getUserInfo(i.receiverUid);
       if (tempProfile != null && context.mounted) {
         chatHistoryProfile.add(ChatHistoryProfileModel(i, tempProfile??DataConstant().getTempProfile(context)));
       }
     }
    }
    progressing = Progressing.idle;
    notifyListeners();
  }
}

class ChatHistoryProfileModel{
  late ChatHistoryModel chatHistoryModel;
  late ProfileModel profileModel;

  ChatHistoryProfileModel(this.chatHistoryModel, this.profileModel);
}
