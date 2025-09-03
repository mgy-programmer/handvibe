import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/give_break.dart';
import 'package:handvibe/view/organism/profile_banner.dart';
import 'package:handvibe/view/organism/show_products.dart';
import 'package:handvibe/view/page/chat_pages/chat_page.dart';
import 'package:handvibe/view/page/login_pages/login_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final ProfileModel profileModel;
  final String myID;

  const ProfilePage({super.key, required this.profileModel, required this.myID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController scrollController = ScrollController();
  int limit = 10;
  late bool follow;

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    follow = widget.profileModel.followers.contains(widget.myID);
    Provider.of<ProductProvider>(context, listen: false).getUserProducts(widget.profileModel.profileId, limit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          limit += 10;
          Provider.of<ProductProvider>(context, listen: false).getUserProducts(widget.profileModel.profileId, limit);
        }
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, widgets) {
      return userProvider.progressing != Progressing.busy
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.profileModel.nameAndSurname,
                  style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (userProvider.myProfile != null) {
                    UsefulMethods().navigatorPushMethod(
                      context,
                      ChatPage(
                        receiverProfile: widget.profileModel,
                        myProfile: userProvider.myProfile!,
                      ),
                    );
                  } else {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => LoginPage(),
                    );
                  }
                },
                backgroundColor: ColorBank().white,
                child: Icon(
                  Icons.chat_bubble,
                  color: ColorBank().primary,
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorBank().background,
                      ),
                      child: Column(
                        children: [
                          ProfileBanner(
                            profile: widget.profileModel,
                            follow: userProvider.myProfile != null ? follow ?? userProvider.myProfile!.followers.contains(widget.profileModel.profileId) : false,
                            followAction: () async {
                              if (widget.myID != "") {
                                if (!follow) {
                                  widget.profileModel.followers.add(widget.myID);
                                  await FireStoreUser().updateUser(widget.profileModel, widget.profileModel.profileId);

                                  userProvider.myProfile!.following.add(widget.profileModel.profileId);
                                  await FireStoreUser().updateUser(userProvider.myProfile!, widget.myID);
                                } else {
                                  widget.profileModel.followers.remove(widget.myID);
                                  await FireStoreUser().updateUser(widget.profileModel, widget.profileModel.profileId);

                                  userProvider.myProfile!.following.remove(widget.profileModel.profileId);
                                  await FireStoreUser().updateUser(userProvider.myProfile!, widget.myID);
                                }
                                fillData();
                              } else {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => LoginPage(),
                                );
                              }
                            },
                          ),
                          GiveBreak(),
                          Consumer2<ProductProvider, UserProvider>(builder: (context, productProvider, userProvider, widgets) {
                            return ShowProducts(
                              products: productProvider.userProducts,
                              scrollController: scrollController,
                              myProfile: userProvider.myProfile,
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: ColorBank().secondaryText,
              ),
            );
    });
  }
}
