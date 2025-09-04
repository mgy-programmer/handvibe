import 'package:flutter/cupertino.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model_view/firebase/firebase_category.dart';
import 'package:handvibe/utility/enum.dart';

class CategoryProvider extends ChangeNotifier{
  List<CategoryModel> categories = [];
  Progressing progressing = Progressing.idle;

  getAllCategory()async{
    progressing = Progressing.busy;
    categories = await FirebaseCategory().getCategoryList();
    progressing = Progressing.idle;
    notifyListeners();
  }
}