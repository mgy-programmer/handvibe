import 'dart:io';

import 'package:handvibe/utility/useful_methods.dart';

class ProfileModel {
  late String profileId;
  late String email;
  late String name;
  late String surname;
  late String nameAndSurname;
  late String username;
  late String profileImagePath;
  late List<String> deviceToken;
  late String selectedLanguage;
  DateTime? lastEntry;
  late String phoneCode;
  late String phoneNumber;
  late bool phoneVerified;
  late String country;
  late String address;
  late String about;
  late String platform;
  late double totalScore;
  late int countScore;
  late DateTime joinDate;
  late List<String> followers;
  late List<String> following;
  late List<String> products;
  late List<String> savedProducts;

  ProfileModel(
    this.email,
    this.name,
    this.surname,
    this.nameAndSurname,
    this.username,
    this.deviceToken,
    this.selectedLanguage,
    this.joinDate,
    this.platform, {
    this.profileId = "",
    this.profileImagePath = "",
    this.lastEntry,
    this.phoneCode = "",
    this.phoneNumber = "",
    this.phoneVerified = false,
    this.country = "",
    this.address = "",
    this.about = "",
    this.totalScore = 0,
    this.countScore = 0,
    this.following = const [],
    this.followers = const [],
    this.products = const [],
    this.savedProducts = const [],
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    profileId = json["profileId"];
    email = json["email"];
    name = json["name"];
    surname = json["surname"];
    nameAndSurname = json["nameAndSurname"] ?? "${json["name"]} ${json["surname"]}";
    username = json["username"];
    deviceToken = UsefulMethods().dynamicListToStringList(json["deviceToken"]);
    selectedLanguage = json["selectedLanguage"];
    profileImagePath = json["profileImagePath"] ?? "";
    lastEntry = json["lastEntry"]?.toDate();
    phoneCode = json["phoneCode"] ?? "";
    phoneNumber = json["phoneNumber"] ?? "";
    phoneVerified = json["phoneVerified"] ?? false;
    country = json["country"] ?? "";
    address = json["address"] ?? "";
    about = json["about"] ?? "";
    totalScore = json["totalScore"] ?? 0;
    countScore = json["countScore"] ?? 0;
    joinDate = DateTime.parse(json["joinDate"]);
    platform = json["platform"] ?? Platform.operatingSystem;
    following = UsefulMethods().dynamicListToStringList(json["following"]);
    followers = UsefulMethods().dynamicListToStringList(json["followers"]);
    products = json["products"] != null ? UsefulMethods().dynamicListToStringList(json["products"]) : [];
    savedProducts = json["savedProducts"] != null ? UsefulMethods().dynamicListToStringList(json["savedProducts"]) : [];
  }

  Map<String, dynamic> toJson() {
    return {
      "profileId": profileId,
      "email": email,
      "name": name,
      "surname": surname,
      "nameAndSurname": nameAndSurname,
      "username": username,
      "deviceToken": deviceToken,
      "selectedLanguage": selectedLanguage,
      "profileImagePath": profileImagePath,
      "lastEntry": lastEntry,
      "phoneCode": phoneCode,
      "phoneNumber": phoneNumber,
      "phoneVerified": phoneVerified,
      "country": country,
      "address": address,
      "about": about,
      "totalScore": totalScore,
      "countScore": countScore,
      "platform": platform,
      "joinDate": joinDate.toString(),
      "followers": followers,
      "following": following,
      "products": products,
      "savedProducts": savedProducts,
    };
  }

  @override
  String toString() {
    return 'ProfileModel{profileId: $profileId, email: $email, name: $name, surname: $surname, nameAndSurname: $nameAndSurname, username: $username, profileImagePath: $profileImagePath, deviceToken: $deviceToken, selectedLanguage: $selectedLanguage, lastEntry: $lastEntry, phoneCode: $phoneCode, phoneNumber: $phoneNumber, phoneVerified: $phoneVerified, country: $country, address: $address, about: $about, platform: $platform, joinDate: $joinDate, followers: $followers, following: $following, products: $products, savedProducts: $savedProducts}';
  }
}
