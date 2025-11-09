import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handvibe/model/media_hide_model.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model_view/firebase/firebase_product.dart';
import 'package:handvibe/model_view/firebase/firebase_storage.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/give_break.dart';
import 'package:handvibe/view/atom/hobi_options.dart';
import 'package:handvibe/view/atom/input_text.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/molecule/hobi_button.dart';
import 'package:handvibe/view/molecule/sell_product_image_list.dart';
import 'package:handvibe/view/template/currency_dialog.dart';
import 'package:handvibe/view/template/select_category_dialog.dart';
import 'package:handvibe/view/template/warning_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellProductPage extends StatefulWidget {
  final List<XFile> selectedImages;
  final String uid;

  const SellProductPage(
      {super.key, required this.selectedImages, required this.uid});

  @override
  State<SellProductPage> createState() => _SellProductPageState();
}

class _SellProductPageState extends State<SellProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String productName = "";
  String description = "";
  String price = "";
  String currency = "TRY";
  double hintFont = 16;

  List<CategoryModel> selectedCategories = [];
  List<String> selectedCategoryIds = [];
  List<MediaHideModel> newPath = [];
  List<XFile> selectedImage = [];

  Progressing progressing = Progressing.idle;

  @override
  void initState() {
    selectedImage = widget.selectedImages;
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("share_product")),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SellProductImageList(
                selectedImages: selectedImage,
                returnedList: (value){

                },
              ),
              GiveBreak(
                height: 50,
              ),
              InputText(
                controller: productNameController,
                hintText:
                    AppLocalizations.of(context)!.translate("product_name"),
                onChanged: (value) {
                  productName = value;
                },
                hintStyleFont: hintFont,
                hintColor: ColorBank().hinTextColor,
                width: ScreenSizeUtil().getCalculateWith(context, 330),
              ),
              GiveBreak(),
              Container(
                width: ScreenSizeUtil().getCalculateWith(context, 330),
                margin: EdgeInsets.only(
                  left: ScreenSizeUtil().getCalculateWith(context, 20),
                  right: ScreenSizeUtil().getCalculateWith(context, 20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputText(
                      width: ScreenSizeUtil().getCalculateWith(context, 200),
                      controller: priceController,
                      hintText: AppLocalizations.of(context)!
                          .translate("product_price"),
                      onChanged: (value) {
                        price = value;
                      },
                      hintStyleFont: hintFont,
                      hintColor: ColorBank().hinTextColor,
                      inputType: TextInputType.number,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => CurrencyDialog(
                            returnedCurrency: (value) {
                              setState(() {
                                currency = value;
                              });
                            },
                            selectedCurrency: currency,
                          ),
                        );
                      },
                      child: Container(
                        width: ScreenSizeUtil().getCalculateWith(context, 100),
                        padding: EdgeInsets.only(
                          top: ScreenSizeUtil().getCalculateHeight(context, 12),
                          bottom:
                              ScreenSizeUtil().getCalculateHeight(context, 12),
                          left: ScreenSizeUtil().getCalculateWith(context, 10),
                          right: ScreenSizeUtil().getCalculateWith(context, 10),
                        ),
                        decoration: BoxDecoration(
                          color: ColorBank().white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            currency,
                            style: TextFont().ralewayRegularMethod(
                                18, ColorBank().black, context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GiveBreak(),
              HobiOptions(
                hintFont: hintFont,
                width: ScreenSizeUtil().getCalculateWith(context, 330),
                text: selectedCategories.isEmpty
                    ? AppLocalizations.of(context)!
                        .translate("select_product_category")
                    : "${selectedCategories.length} ${AppLocalizations.of(context)!.translate("count_selected")}",
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => SelectCategoryDialog(
                      selectedCategories: (value) {
                        setState(() {
                          selectedCategoryIds = [];
                          selectedCategories = value;
                          for(var i in selectedCategories){
                            selectedCategoryIds.add(i.categoryId);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
              GiveBreak(),
              InputText(
                controller: descriptionController,
                hintText: AppLocalizations.of(context)!
                    .translate("product_description"),
                onChanged: (value) {
                  description = value;
                },
                hintStyleFont: hintFont,
                hintColor: ColorBank().hinTextColor,
                maxLength: 300,
                maxLines: 5,
                width: ScreenSizeUtil().getCalculateWith(context, 330),
              ),
              GiveBreak(),
              Consumer<UserProvider>(builder: (context, userProvider, widgets) {
                return HobiButton(
                  text: AppLocalizations.of(context)!.translate("save"),
                  backgroundColor: ColorBank().primary,
                  onTap: () async {
                    if (productName != "" &&
                        description != "" &&
                        price != "" &&
                        selectedCategories.isNotEmpty) {
                      setState(() {
                        progressing = Progressing.busy;
                      });
                      String uniqueId =
                          UsefulMethods().generate32BitKey(widget.uid);
                      for (int i = 0; i < selectedImage.length; i++) {
                        String path =
                            await FirebaseStorageMethods().addImageToFirebase(
                          File(selectedImage[i].path),
                          "$uniqueId - $i",
                          Constants().products,
                          70,
                        );
                        newPath.add(MediaHideModel(path, "$uniqueId - $i"));
                      }
                      await FirebaseProduct().addProduct(
                        ProductModel(
                          uniqueId,
                          widget.uid,
                          productName,
                          newPath,
                          description,
                          selectedCategories,
                          selectedCategoryIds,
                          price,
                          currency,
                          DateTime.now(),
                        ),
                      );
                      List<String> products = userProvider.myProfile!.products;
                      products.add(uniqueId);
                      await FireStoreUser()
                          .updateProducts(widget.uid, products);
                      setState(() {
                        progressing = Progressing.idle;
                      });
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => WarningDialog(
                          dialogTitle: AppLocalizations.of(context)!
                              .translate("warning"),
                          content: AppLocalizations.of(context)!
                              .translate("fill_input"),
                        ),
                      );
                    }
                  },
                  textColor: ColorBank().white,
                );
              }),
            ],
          ),
          progressing == Progressing.busy
              ? Align(
                  alignment: Alignment(0, 0),
                  child: LoadingWidget(),
                )
              : Container(),
        ],
      ),
    );
  }
}
