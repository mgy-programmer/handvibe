import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handvibe/model_view/firebase/firebase_chat.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/add_button.dart';
import 'package:handvibe/view/atom/nav_option.dart';
import 'package:handvibe/view/atom/nov_icon.dart';
import 'package:handvibe/view/molecule/stream_icon.dart';
import 'package:handvibe/view/page/login_pages/login_page.dart';
import 'package:handvibe/view/page/product_pages/sell_product_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final String myId;
  final Function(int, Progressing) returnSelectedIndex;

  const NavBar({super.key, required this.myId, required this.returnSelectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedIndex = 0;
  List<XFile> selectedImages = [];
  Progressing progressing = Progressing.idle;

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    if (widget.myId != "") {
      Provider.of<UserProvider>(context, listen: false).getMyProfile(widget.myId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSizeUtil().getCalculateHeight(context, 65),
      margin: EdgeInsets.only(
        bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
        left: ScreenSizeUtil().getCalculateWith(context, 10),
        right: ScreenSizeUtil().getCalculateWith(context, 10),
      ),
      decoration: BoxDecoration(
        color: ColorBank().white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: ColorBank().inputBackgroundColor)
      ),
      padding: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavOption(
            iconActivePath: ImageConstant().homepageActive,
            iconPassivePath: ImageConstant().homepagePassive,
            optionName: AppLocalizations.of(context)!.translate("homepage"),
            selectedIndex: selectedIndex,
            index: 0,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
                widget.returnSelectedIndex(value, progressing);
              });
            },
          ),
          widget.myId != ""
              ? StreamIcon(
                  stream: FirebaseChat().getConversationHistory(widget.myId),
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                      widget.returnSelectedIndex(1, progressing);
                    });
                  },
                  iconPassivePath: ImageConstant().chatPassive,
                  iconActivePath: ImageConstant().chatActive,
                  selectedIndex: selectedIndex,
                  index: 1,
                  text: AppLocalizations.of(context)!.translate("chat"),
                )
              : NavIcon(
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => LoginPage(),
                    );
                    fillData();
                  },
                  selectedIndex: selectedIndex,
                  iconPassivePath: ImageConstant().chatPassive,
                  iconActivePath: ImageConstant().chatActive,
                  index: 1,
                  text: AppLocalizations.of(context)!.translate("chat"),
                  isSeen: true,
                ),
          AddButton(
            onTap: () async {
              if (widget.myId != "") {
                setState(() {
                  progressing != Progressing.busy;
                });
                try {
                  selectedImages = await ImagePicker().pickMultiImage();
                  if (selectedImages.isNotEmpty) {
                    if (context.mounted) {
                      await UsefulMethods().navigatorPushMethod(
                        context,
                        SellProductPage(
                          selectedImages: selectedImages,
                          uid: widget.myId,
                        ),
                      );
                    }
                    if (context.mounted) {
                      Provider.of<ProductProvider>(context, listen: false).getProductsWithLimit(10);
                    }
                  }
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
                setState(() {
                  progressing != Progressing.idle;
                });
              } else {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => LoginPage(),
                );
                fillData();
              }
            },
          ),
          NavOption(
            iconActivePath: ImageConstant().categoriesActive,
            iconPassivePath: ImageConstant().categoriesPassive,
            optionName: AppLocalizations.of(context)!.translate("my_ads"),
            selectedIndex: selectedIndex,
            index: 2,
            onTap: (value) async {
              if (widget.myId != "") {
                setState(() {
                  selectedIndex = value;
                  widget.returnSelectedIndex(value, progressing);
                });
              } else {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => LoginPage(),
                );
                fillData();
              }
            },
          ),
          NavOption(
            iconActivePath: ImageConstant().profileActive,
            iconPassivePath: ImageConstant().profilePassive,
            optionName: AppLocalizations.of(context)!.translate("profile"),
            selectedIndex: selectedIndex,
            index: 3,
            onTap: (value) async {
              if (widget.myId != "") {
                setState(() {
                  selectedIndex = value;
                  widget.returnSelectedIndex(value, progressing);
                });
              } else {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => LoginPage(),
                );
                fillData();
              }
            },
          ),
        ],
      ),
    );
  }
}
