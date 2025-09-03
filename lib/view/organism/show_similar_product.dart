import 'package:flutter/material.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/page/product_pages/my_product_detail.dart';
import 'package:handvibe/view/page/product_pages/product_detail.dart';
import 'package:provider/provider.dart' show Consumer;

class ShowSimilarProduct extends StatefulWidget {
  final ProductModel productModel;
  final String myId;

  const ShowSimilarProduct({super.key, required this.productModel, required this.myId});

  @override
  State<ShowSimilarProduct> createState() => _ShowSimilarProductState();
}

class _ShowSimilarProductState extends State<ShowSimilarProduct> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, widgets) {
      return productProvider.productsByCategoryList.length > 1
          ? Container(
              margin: EdgeInsets.only(
                top: ScreenSizeUtil().getCalculateHeight(context, 10),
                left: ScreenSizeUtil().getCalculateWith(context, 10),
                right: ScreenSizeUtil().getCalculateWith(context, 10),
                bottom: ScreenSizeUtil().getCalculateHeight(context, 50)
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.translate("similar_products"),
                      style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSizeUtil().getCalculateHeight(context, 150),
                    child: ListView.builder(
                      itemCount: productProvider.productsByCategoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return productProvider.productsByCategoryList[index].productId != widget.productModel.productId
                            ? Container(
                                margin: EdgeInsets.only(
                                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.myId != productProvider.productsByCategoryList[index].sellerId) {
                                      UsefulMethods().navigatorPushMethod(context, ProductDetail(productModel: productProvider.productsByCategoryList[index], myId: widget.myId));
                                    } else {
                                      UsefulMethods().navigatorPushMethod(context, MyProductDetail(productModel: productProvider.productsByCategoryList[index], myID: widget.myId));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: ScreenSizeUtil().getCalculateWith(context, 150),
                                          height: ScreenSizeUtil().getCalculateWith(context, 100),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(27),
                                              bottomRight: Radius.circular(27),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(27),
                                            child: Image.network(
                                              productProvider.productsByCategoryList[index].productImages.first.mediaPath,
                                              fit: BoxFit.fill,
                                              width: ScreenSizeUtil().getCalculateWith(context, 100),
                                              height: ScreenSizeUtil().getCalculateWith(context, 100),
                                              errorBuilder: (context, obj, stacktrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(360),
                                                    border: Border.all(color: ColorBank().white),
                                                    color: ColorBank().white,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(360),
                                                    child: Image.asset(
                                                      ImageConstant().logo,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: ScreenSizeUtil().getCalculateWith(context, 150),
                                          decoration: BoxDecoration(
                                            color: ColorBank().white,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(27),
                                              bottomRight: Radius.circular(27),
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                            top: ScreenSizeUtil().getCalculateHeight(context, 5),
                                            bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
                                            left: ScreenSizeUtil().getCalculateWith(context, 10),
                                            right: ScreenSizeUtil().getCalculateWith(context, 10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                productProvider.productsByCategoryList[index].productName,
                                                style: TextFont().ralewayRegularMethod(16, ColorBank().black, context),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "${productProvider.productsByCategoryList[index].price} ${productProvider.productsByCategoryList[index].currency}",
                                                style: TextFont().ralewayRegularMethod(14, ColorBank().black, context),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }
}
