import 'package:flutter/material.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/organism/nav_bar.dart';
import 'package:handvibe/view/page/ads_pages/my_ads_list.dart';
import 'package:handvibe/view/page/chat_pages/chat_history_page.dart';
import 'package:handvibe/view/page/main_pages/homepage.dart';
import 'package:handvibe/view/page/profile_pages/my_profile_page.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  final String myId;

  const BaseScreen({super.key, required this.myId});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int selectedIndex = 0;
  Progressing progressing = Progressing.idle;

  @override
  void initState() {
    if (widget.myId != "") {
      Provider.of<UserProvider>(context, listen: false).getMyProfile(widget.myId);
    }
    if (mounted) FocusManager.instance.primaryFocus?.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorBank().white,
        body: SafeArea(
          child: Consumer<UserProvider>(builder: (context, userProvider, widgets) {
            return userProvider.progressing != Progressing.busy
                ? Stack(
                    children: [
                      selectedIndex == 0
                          ? Homepage(
                              myProfile: userProvider.myProfile,
                            )
                          : selectedIndex == 1
                              ? ChatHistory(
                                  myProfile: userProvider.myProfile!,
                                )
                              : selectedIndex == 2
                                  ? MyAdsList(
                                      myProfile: userProvider.myProfile!,
                                    )
                                  : selectedIndex == 3
                                      ? MyProfilePage(
                                          uid: widget.myId,
                                        )
                                      : Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: NavBar(
                          myId: widget.myId,
                          returnSelectedIndex: (value, returnProgressing) {
                            setState(() {
                              selectedIndex = value;
                              progressing = returnProgressing;
                            });
                          },
                        ),
                      ),
                      progressing == Progressing.busy ? LoadingWidget() : Container()
                    ],
                  )
                : LoadingWidget();
          }),
        ),
      ),
    );
  }
}
