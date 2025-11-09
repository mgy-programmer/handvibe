import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class CategoryButton extends StatelessWidget {
  final String path;
  final CategoryModel categoryModel;
  final Function() onTap;

  const CategoryButton(
      {super.key, required this.path, required this.onTap, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: ScreenSizeUtil().getCalculateWith(context, 50),
              height: ScreenSizeUtil().getCalculateWith(context, 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: ColorBank().white,
              ),
              margin: EdgeInsets.only(
                right: ScreenSizeUtil().getCalculateWith(context, 5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: SvgPicture.asset(
                  path,
                  width: ScreenSizeUtil().getCalculateWith(context, 50),
                  height: ScreenSizeUtil().getCalculateWith(context, 50),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: ScreenSizeUtil().getCalculateWith(context, 50),
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 5),
              ),
              child: Text(
                AppLocalizations.of(context)!.locale.languageCode == "en" ? categoryModel.categoryNameEN : categoryModel.categoryNameTR,
                style: TextFont().ralewayBoldMethod(12, ColorBank().primary, context),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
