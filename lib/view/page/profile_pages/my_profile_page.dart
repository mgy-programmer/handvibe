import 'package:flutter/material.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/view/atom/give_break.dart';
import 'package:handvibe/view/molecule/user_info.dart';
import 'package:handvibe/view/organism/my_profile_banner.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  final String uid;

  const MyProfilePage({super.key, required this.uid});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getMyProfile(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, widgets) {
      return userProvider.progressing != Progressing.busy
          ? Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorBank().white,
                    ),
                    child: Column(
                      children: [
                        MyProfileBanner(
                          myProfile: userProvider.myProfile!,
                        ),
                        GiveBreak(),
                        UserInfo(myProfile: userProvider.myProfile!),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: ColorBank().secondaryText,
              ),
            );
    });
  }
}
