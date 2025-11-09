import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/molecule/main_page_product_title.dart';

class MainPageCategoryList extends StatelessWidget {
  final Function() onTapMore;
  final CategoryModel categoryModel;
  final List<ProductModel> products;

  const MainPageCategoryList({super.key, required this.onTapMore, required this.categoryModel, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
        bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
      ),
      child: Column(
        children: [
          MainPageProductTitle(
            title: categoryModel.categoryDescriptionTR,
            onTapMore: () {},
          ),
          Container(
            width: ScreenSizeUtil().getCalculateWith(context, 400),
            height: ScreenSizeUtil().getCalculateHeight(context, 150),
            margin: EdgeInsets.only(
              top: ScreenSizeUtil().getCalculateHeight(context, 10),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  width: ScreenSizeUtil().getCalculateWith(context, 150),
                  height: ScreenSizeUtil().getCalculateHeight(context, 150),
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: ScreenSizeUtil().getCalculateWith(context, 150),
                        height: ScreenSizeUtil().getCalculateHeight(context, 150),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            products[index].productImages.first.mediaPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: ScreenSizeUtil().getCalculateHeight(context, 50),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              )),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              left: ScreenSizeUtil().getCalculateWith(context, 10),
                              right: ScreenSizeUtil().getCalculateWith(context, 10),
                              bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[index].productName,
                                  style: TextStyle(
                                    color: ColorBank().bodyText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.translate("price")}: ${products[index].price}",
                                  style: TextStyle(
                                    color: ColorBank().bodyText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
