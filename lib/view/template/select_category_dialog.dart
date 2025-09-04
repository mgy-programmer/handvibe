import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model_view/provider/category_provider.dart';
import 'package:handvibe/model_view/provider/language_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:provider/provider.dart';

class SelectCategoryDialog extends StatefulWidget {
  final Function(List<CategoryModel>) selectedCategories;

  const SelectCategoryDialog({super.key, required this.selectedCategories});

  @override
  State<SelectCategoryDialog> createState() => _SelectCategoryDialogState();
}

class _SelectCategoryDialogState extends State<SelectCategoryDialog> {
  List<CategoryModel> selectedCategories = [];
  String langCode = "";

  @override
  void initState() {
    fillData();
    Provider.of<CategoryProvider>(context, listen: false).getAllCategory();
    super.initState();
  }

  fillData() async {
    langCode = await SharedPreferencesMethods().getSelectedLanguage();
    print(langCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, widgets) {
      return Scaffold(
        backgroundColor: ColorBank().background.withValues(alpha: 0.2),
        body: Container(
          margin: EdgeInsets.only(
            left: ScreenSizeUtil().getCalculateWith(context, 10),
            right: ScreenSizeUtil().getCalculateWith(context, 10),
            top: ScreenSizeUtil().getCalculateHeight(context, 10),
            bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
          ),
          padding: EdgeInsets.only(
            left: ScreenSizeUtil().getCalculateWith(context, 10),
            right: ScreenSizeUtil().getCalculateWith(context, 10),
            top: ScreenSizeUtil().getCalculateHeight(context, 10),
            bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
          ),
          decoration: BoxDecoration(
            color: ColorBank().white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: categoryProvider.progressing != Progressing.busy
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ScreenSizeUtil().getCalculateHeight(context, 600),
                      child: ListView.builder(
                        itemCount: categoryProvider.categories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (selectedCategories.contains(categoryProvider.categories[index])) {
                                setState(() {
                                  selectedCategories.remove(categoryProvider.categories[index]);
                                });
                              } else {
                                setState(() {
                                  selectedCategories.add(categoryProvider.categories[index]);
                                });
                              }
                            },
                            title: Text(
                              langCode == "en" ? categoryProvider.categories[index].categoryNameEN : categoryProvider.categories[index].categoryNameTR,
                              style: TextFont().ralewayBoldMethod(16, ColorBank().black, context),
                            ),
                            subtitle: Text(
                              langCode == "en" ? categoryProvider.categories[index].categoryDescriptionEN : categoryProvider.categories[index].categoryDescriptionTR,
                              style: TextFont().ralewayRegularMethod(14, ColorBank().hinTextColor, context),
                            ),
                            trailing: Container(
                              width: ScreenSizeUtil().getCalculateWith(context, 24),
                              height: ScreenSizeUtil().getCalculateWith(context, 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorBank().black),
                              ),
                              child: selectedCategories.contains(categoryProvider.categories[index])
                                  ? Icon(
                                      Icons.check,
                                      color: ColorBank().primary,
                                    )
                                  : Container(),
                            ),
                          );
                        },
                      ),
                    ),
                    HobiButton(
                      text: AppLocalizations.of(context)!.translate("ok"),
                      backgroundColor: ColorBank().primary,
                      onTap: () {
                        widget.selectedCategories(selectedCategories);
                        Navigator.pop(context);
                      },
                      textColor: ColorBank().white,
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: ColorBank().primary,
                  ),
                ),
        ),
      );
    });
  }
}
