import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model_view/provider/category_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:provider/provider.dart';

import '../../model_view/provider/language_provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<CategoryModel> selectedCategories = [];
  String langCode = "";

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getAllCategory();
    fillData();
    super.initState();
  }


  fillData()async{
    langCode = await SharedPreferencesMethods().getSelectedLanguage();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CategoryProvider>(builder: (context, categoryProvider, widgets) {
        return Container(
          margin: EdgeInsets.only(
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
                  children: [
                    SizedBox(
                      height: ScreenSizeUtil().getCalculateHeight(context, 670),
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
                              langCode != ""
                                  ? langCode == "tr"
                                  ? categoryProvider.categories[index].categoryNameTR
                                  : categoryProvider.categories[index].categoryNameEN
                                  : categoryProvider.categories[index].categoryNameEN,
                              style: TextFont().ralewayRegularMethod(16, ColorBank().white, context),
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
        );
      }),
    );
  }
}
