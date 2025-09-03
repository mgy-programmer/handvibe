import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_product.dart';
import 'package:handvibe/model_view/provider/category_provider.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/data_constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/molecule/list_of_categories.dart';
import 'package:handvibe/view/page/main_pages/search_page.dart';
import 'package:handvibe/view/template/homepage_products.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final ProfileModel? myProfile;

  const Homepage({super.key, required this.myProfile});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String uid = "";

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    await Future.delayed(Duration(milliseconds: 20));
    if (mounted) Provider.of<CategoryProvider>(context, listen: false).getAllCategory();
    uid = await SharedPreferencesMethods().getUserID();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: ()async{
              UsefulMethods().navigatorPushMethod(context, SearchPage());
              /*List<ProductModel> products = ProductDummyData().dummy_data;

              for(var i in products){
                await FirebaseProduct().addProduct(i);
                print("Eklendi");
              }
              Provider.of<ProductProvider>(context,listen: false).getProductsWithLimit(20);*/
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 5),
                bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
                left: ScreenSizeUtil().getCalculateWith(context, 10),
                right: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 10),
                bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                left: ScreenSizeUtil().getCalculateWith(context, 10),
                right: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              decoration: BoxDecoration(
                color: ColorBank().background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    ImageConstant().searchIcon,
                    width: ScreenSizeUtil().getCalculateWith(context, 30),
                    height: ScreenSizeUtil().getCalculateWith(context, 30),
                    colorFilter: ColorFilter.mode(ColorBank().primary, BlendMode.srcIn),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenSizeUtil().getCalculateWith(context, 10),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate("search"),
                      style: TextFont().ralewayRegularMethod(21, ColorBank().inputBackgroundColor, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListOfCategories(
            myProfile: widget.myProfile,
          ),
          HomepageProducts(
            myId: uid,
          ),
        ],
      ),
    );
  }
}
