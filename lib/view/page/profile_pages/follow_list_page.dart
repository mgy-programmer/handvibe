import 'package:flutter/material.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:provider/provider.dart';

class FollowListPage extends StatefulWidget {
  final List<String> followList;

  const FollowListPage({super.key, required this.followList});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  int limit = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() {
    Provider.of<UserProvider>(context, listen: false).getFollowList(widget.followList, limit);
    scrollController = ScrollController()
      ..addListener(() {
        limit += 10;
        Provider.of<UserProvider>(context, listen: false).getFollowList(widget.followList, limit);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("followers"),
          style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, widgets) {
        return userProvider.progressing != Progressing.busy
            ? ListView.builder(
                controller: scrollController,
                itemCount: userProvider.profileModelList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: ScreenSizeUtil().getCalculateWith(context, 10),
                      right: ScreenSizeUtil().getCalculateWith(context, 10),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorBank().background),
                      ),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: Image.network(
                          userProvider.profileModelList[index].profileImagePath,
                          fit: BoxFit.fill,
                          width: ScreenSizeUtil().getCalculateWith(context, 40),
                          height: ScreenSizeUtil().getCalculateWith(context, 40),
                        ),
                      ),
                      title: Text(userProvider.profileModelList[index].nameAndSurname, style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),),
                      subtitle: Text(userProvider.profileModelList[index].username, style: TextFont().ralewayThinMethod(16, ColorBank().buttonDisabled, context),),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  color: ColorBank().primary,
                ),
              );
      }),
    );
  }
}
