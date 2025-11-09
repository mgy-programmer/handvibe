import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/organism/product_card.dart';
import 'package:handvibe/view/page/product_pages/my_product_detail.dart';
import 'package:handvibe/view/page/product_pages/product_detail.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  int limit = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    openKeyboard();
    super.initState();
  }

  openKeyboard()async{
    await Future.delayed(Duration(milliseconds: 20));
    if(mounted) UsefulMethods().openKeyboard(context);
  }

  fillData(String text) async {
    if(text.length > 3){
      Provider.of<ProductProvider>(context, listen: false).getSearchedProductsWithLimit(limit, text);
      scrollController = ScrollController()
        ..addListener(() {
          if (scrollController.position.atEdge) {
            limit += 10;
            Provider.of<ProductProvider>(context, listen: false).getSearchedProductsWithLimit(limit, text);
          }
        });
    }
    else if (text == ""){
      Provider.of<ProductProvider>(context, listen: false).clearSearchedProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: ColorBank().primary,
      ),
      body: Consumer<ProductProvider>(builder: (context, productProvider, widgets) {
        return Column(
          children: [
            Container(
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
              child: TextField(
                autofocus: true,
                controller: searchController,
                onChanged: (value) {
                  fillData(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.translate("search"),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(ScreenSizeUtil().getCalculateWith(context, 5)),
                    child: SvgPicture.asset(
                      ImageConstant().searchIcon,
                      colorFilter: ColorFilter.mode(ColorBank().primary, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenSizeUtil().getCalculateHeight(context, 500),
              padding: EdgeInsets.only(
                left: ScreenSizeUtil().getCalculateWith(context, 10),
                right: ScreenSizeUtil().getCalculateWith(context, 10),
              ),
              child: Consumer2<ProductProvider, UserProvider>(builder: (context, productProvider, userProvider, widgets) {
                return GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: productProvider.searchedProduct.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      favoriteIconStatus: true,
                      productModel: productProvider.productsWithLimit[index],
                      onTap: () {
                        if (userProvider.myProfile!.profileId != productProvider.productsWithLimit[index].sellerId) {
                          UsefulMethods().navigatorPushMethod(context, ProductDetail(productModel: productProvider.productsWithLimit[index], myId: userProvider.myProfile!.profileId));
                        } else {
                          UsefulMethods().navigatorPushMethod(context, MyProductDetail(productModel: productProvider.productsWithLimit[index], myID: userProvider.myProfile!.profileId));
                        }
                      },
                      myProfile: userProvider.myProfile!,
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
