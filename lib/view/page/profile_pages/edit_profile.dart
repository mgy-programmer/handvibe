import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/methods/backend_methods.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/hobi_options.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/molecule/profile_image.dart';
import 'package:handvibe/view/molecule/profile_image_asset.dart';
import 'package:handvibe/view/template/country_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel myProfile;

  const EditProfile({super.key, required this.myProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController mailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  String name = "";
  String surname = "";
  String country = "";
  String address = "";
  String about = "";

  XFile? selectedImage;

  double hintFont = 14;

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      country = widget.myProfile.country != "" ? widget.myProfile.country : AppLocalizations.of(context)!.translate("select_country");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("edit_profile"),
          style: TextFont().ralewayRegularMethod(18, ColorBank().info, context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: ColorBank().info,
              size: ScreenSizeUtil().getCalculateWith(context, 30),
            ),
            onPressed: () async {
              await BackEndMethods().updateUserProfile(
                context,
                selectedImage != null ? File(selectedImage!.path) : null,
                widget.myProfile.profileId,
                ProfileModel(
                  widget.myProfile.email,
                  name != "" ? name : widget.myProfile.name,
                  surname != "" ? surname : widget.myProfile.surname,
                  UsefulMethods().updateFullName(widget.myProfile.name, name, widget.myProfile.surname, surname),
                  widget.myProfile.username,
                  widget.myProfile.deviceToken,
                  widget.myProfile.selectedLanguage,
                  widget.myProfile.joinDate,
                  widget.myProfile.platform,
                  profileId: widget.myProfile.profileId,
                  phoneCode: widget.myProfile.phoneCode,
                  phoneNumber: widget.myProfile.phoneNumber,
                  phoneVerified: widget.myProfile.phoneVerified,
                  products: widget.myProfile.products,
                  totalScore: widget.myProfile.totalScore,
                  countScore: widget.myProfile.countScore,
                  profileImagePath: widget.myProfile.profileImagePath,
                  address: address != "" ? address : widget.myProfile.address,
                  about: about != "" ? about : widget.myProfile.about,
                  country: country != "" ? country : widget.myProfile.country,
                  followers: widget.myProfile.followers,
                  following: widget.myProfile.following,
                  lastEntry: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 10),
          bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: ScreenSizeUtil().getCalculateWith(context, 120),
                height: ScreenSizeUtil().getCalculateWith(context, 120),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: selectedImage != null
                          ? ProfileImageAsset(
                              profileImagePath: selectedImage!.path,
                              marginLeft: 0,
                              marginRight: 0,
                              width: 100,
                              height: 100,
                              isShadow: false,
                              onProfileImageTap: selectImageFunction,
                            )
                          : ProfileImage(
                              profileImagePath: widget.myProfile.profileImagePath,
                              width: 100,
                              height: 100,
                              onProfileImageTap: selectImageFunction,
                              marginLeft: 0,
                              marginRight: 0,
                            ),
                    ),
                    Align(
                      alignment: Alignment(1, 1),
                      child: SvgPicture.asset(
                        ImageConstant().checkIcon,
                        width: ScreenSizeUtil().getCalculateWith(context, 20),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenSizeUtil().getCalculateHeight(context, 30),
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: InputText(
                  controller: nameController,
                  hintText: widget.myProfile.name != "" ? widget.myProfile.name : AppLocalizations.of(context)!.translate("name"),
                  onChanged: (value) {
                    name = value;
                  },
                  hintStyleFont: hintFont,
                  hintColor: ColorBank().hinTextColor,
                  width: ScreenSizeUtil().getCalculateWith(context, 350),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: InputText(
                  controller: surnameController,
                  hintText: widget.myProfile.surname != "" ? widget.myProfile.surname : AppLocalizations.of(context)!.translate("surname"),
                  onChanged: (value) {
                    surname = value;
                  },
                  hintStyleFont: hintFont,
                  hintColor: ColorBank().hinTextColor,
                  width: ScreenSizeUtil().getCalculateWith(context, 350),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: HobiOptions(
                  margin: 10,
                  width: ScreenSizeUtil().getCalculateWith(context, 350),
                  text: country,
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => CountryDialog(
                        returnedCountry: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                        selectedCountry: country,
                      ),
                    );
                  },
                  hintFont: hintFont,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: InputText(
                  controller: addressController,
                  hintText: widget.myProfile.address != "" ? widget.myProfile.address : AppLocalizations.of(context)!.translate("address"),
                  onChanged: (value) {
                    address = value;
                  },
                  hintStyleFont: hintFont,
                  hintColor: ColorBank().hinTextColor,
                  maxLength: 100,
                  maxLines: 2,
                  width: ScreenSizeUtil().getCalculateWith(context, 350),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: InputText(
                  controller: aboutController,
                  hintText: widget.myProfile.about != "" ? widget.myProfile.about : AppLocalizations.of(context)!.translate("about"),
                  onChanged: (value) {
                    about = value;
                  },
                  hintStyleFont: hintFont,
                  hintColor: ColorBank().hinTextColor,
                  maxLength: 300,
                  maxLines: 5,
                  width: ScreenSizeUtil().getCalculateWith(context, 350),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectImageFunction() async {
    try {
      selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      debugPrint("SelectedImage Path: ${selectedImage!.path}");
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        debugPrint("Error1: $e");
        await openAppSettings();
      }
      return null;
    } catch (e) {
      debugPrint("Error2: $e");
      return null;
    }
  }
}
