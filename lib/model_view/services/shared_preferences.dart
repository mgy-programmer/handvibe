import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethods {
  late SharedPreferences preferences;
  String langCode = "";
  String token = "";
  String email = "";
  String uid = "";
  String deviceToken = "";
  late bool firstTime;


  saveSelectedLanguage(String lngCode) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('langCode', lngCode);
  }

  Future<String> getSelectedLanguage() async {
    preferences = await SharedPreferences.getInstance();
    langCode = preferences.getString('langCode') ?? "";
    return langCode;
  }

  saveFirstTime(bool firstTime) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setBool('firstTime', firstTime);
  }

  Future<bool> getFirstTime() async {
    preferences = await SharedPreferences.getInstance();
    firstTime = preferences.getBool('firstTime') ?? true;
    return firstTime;
  }


  saveDeviceToken(String deviceToken) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('deviceToken', deviceToken);
  }

  Future<String> getDeviceToken() async {
    preferences = await SharedPreferences.getInstance();
    deviceToken = preferences.getString('deviceToken') ?? "";
    return deviceToken;
  }

  Future<String> getUserToken() async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token') ?? "";
    return token;
  }

  setUserToken(String token) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }

  Future<String> getUserEmail() async {
    preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email') ?? "";
    return email;
  }

  setUserEmail(String email) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('email', email);
  }

  Future<String> getUserID() async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('uid') ?? "";
    return token;
  }

  setUserID(String uid) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('uid', uid);
  }

  clearAllInfo()async{
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('uid', "");
    await preferences.setString('token', "");
    await preferences.setString('email', "");
    await preferences.setString('deviceToken', "");
  }
}