import 'package:flutter/cupertino.dart';

class LanguageProvider extends ChangeNotifier {
  List<String> languageCode = ['en', 'tr'];
  String langCode = "";

  setLanguage(String languageCode) {
    langCode = languageCode;
    notifyListeners();
  }
}
