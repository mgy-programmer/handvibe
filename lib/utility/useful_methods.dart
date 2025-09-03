import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'dart:convert' as convert;

import 'package:handvibe/view/template/country_dialog.dart';

class UsefulMethods {
  FocusNode inputNode = FocusNode();
  late Duration duration;
  openKeyboard(BuildContext context) {
    return FocusScope.of(context).requestFocus(inputNode);
  }

  navigatorPushMethod(BuildContext context, Widget page) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page));
  }

  navigatorPushAndNeverComeBackMethod(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => page), (Route<dynamic> route) => false);
  }

  navigatorPushAndThenMethod(BuildContext context, Widget page, Function() function) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page)).then(
      (value) {
        function();
      },
    );
  }

  dynamicListToStringList(List<dynamic> lists) {
    List<String> returnedList = [];
    for (var i in lists) {
      returnedList.add(i);
    }
    return returnedList;
  }

  dynamicListToDoubleList(List<dynamic> lists) {
    List<double> returnedList = [];
    for (var i in lists) {
      returnedList.add(i);
    }
    return returnedList;
  }

  String generate32BitKey(String uid) {
    Random random = Random();
    int key = random.nextInt(1 << 32);
    String generated = key.toRadixString(16).toUpperCase();
    String newGenerated = "$uid - $generated";
    return newGenerated;
  }

  String generateRandomBitKey(int digitCount) {
    Random random = Random();
    int key = random.nextInt(1 << digitCount);
    String generated = key.toRadixString(16).toUpperCase();
    return generated;
  }

  String generateCustomBitKey(int digitCount) {
    Random random = Random();
    int key = random.nextInt(1 << 32);
    String generated = key.toRadixString(16).toUpperCase();
    return generated;
  }
  bool isNumeric(String? str) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(str ?? "");
  }

  bool emailCheck(String email) {
    RegExp exp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return exp.hasMatch(email);
  }

  Future<Uint8List> compressImage(File file, int quality) async {
    final Uint8List uint8List = await file.readAsBytes();
    final Uint8List compressedUint8List = await FlutterImageCompress.compressWithList(
      uint8List,
      quality: quality,
    );
    return compressedUint8List;
  }

  dateTimeToTurkishDate(DateTime? dateTime, BuildContext context) {
    if (dateTime != null) {
      duration = DateTime.now().difference(dateTime);
      if (duration.inSeconds < 60) {
        return "now";
      } else if (duration.inMinutes < 60) {
        return "${duration.inMinutes} ${AppLocalizations.of(context)!.translate("minutes_ago")}";
      } else if (duration.inHours < 24) {
        return "${duration.inHours} ${AppLocalizations.of(context)!.translate("hour_ago")}";
      } else if (duration.inDays < 7) {
        return "${duration.inDays} ${AppLocalizations.of(context)!.translate("day_ago")}";
      } else if (duration.inDays < 30 && duration.inDays >= 7) {
        return "${(duration.inDays / 7).floor()} ${AppLocalizations.of(context)!.translate("week_ago")}";
      } else if (duration.inDays >= 30 && duration.inDays < 365) {
        return "${(duration.inDays / 30).floor()} ${AppLocalizations.of(context)!.translate("month_ago")}";
      } else if (duration.inDays >= 365) {
        return "${(duration.inDays / 365).floor()} ${AppLocalizations.of(context)!.translate("year_ago")}";
      }
    } else {
      return AppLocalizations.of(context)!.translate("now");
    }
  }

  loadCountryFromJson() async {
    final jsonString = await rootBundle.loadString('assets/json/country.json');
    final jsonData = convert.jsonDecode(jsonString);
    List<dynamic> temp = jsonData.toList();
    List<CountryModel> countryList = [];
    for (var i in temp) {
      countryList.add(CountryModel.fromJson(i));
    }
    return countryList;
  }

  String updateFullName(String oldName, String newName, String oldSurname, String newSurname) {
    if (oldName == newName && oldSurname == newSurname) {
      return "$oldName $oldSurname";
    }
    else if (oldName != newName && oldSurname == newSurname) {
      return "$newName $oldSurname";
    }
    else if (oldName == newName && oldSurname != newSurname) {
      return "$newName $newSurname";
    }
    else {
      return "$newName $newSurname";
    }
  }

}
