import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/evaluation_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/utility/enum.dart';

class UserProvider extends ChangeNotifier{
  ProfileModel? myProfile;
  ProfileModel? userProfile;
  List<ProfileModel> profileModelList = [];
  List<EvaluationModel> evaluationModels = [];
  Progressing progressing = Progressing.idle;

  getMyProfile(String uid)async{
    progressing = Progressing.busy;
    myProfile = await FireStoreUser().getUserInfo(uid);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getUserProfile(String uid)async{
    progressing = Progressing.busy;
    userProfile = await FireStoreUser().getUserInfo(uid);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getFollowList(List<String> followList, int limit)async{
    progressing = Progressing.busy;
    profileModelList = await FireStoreUser().getFollowList(followList, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }

  getAllEvaluationList(String sellerId, int limit)async{
    progressing = Progressing.busy;
    evaluationModels = await FireStoreUser().getAllSellerEvaluationList(sellerId, limit);
    progressing = Progressing.idle;
    notifyListeners();
  }
}