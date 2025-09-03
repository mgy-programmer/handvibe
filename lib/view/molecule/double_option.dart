import 'package:flutter/material.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/atom/tab_option_button.dart';

class DoubleOption extends StatelessWidget {
  final Function(int) returnedIndex;
  final int index;

  const DoubleOption({super.key, required this.returnedIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: ScreenSizeUtil().getCalculateHeight(context, 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabOptionButton(
              onTap: () {
                returnedIndex(0);
              },
              text: AppLocalizations.of(context)!.translate("my_store"),
              index: 0,
              selectedIndex: index,
            ),
            TabOptionButton(
              onTap: () {
                returnedIndex(1);
              },
              text: AppLocalizations.of(context)!.translate("saved_product"),
              index: 1,
              selectedIndex: index,
            ),
          ],
        ),
      ),
    );
  }
}
