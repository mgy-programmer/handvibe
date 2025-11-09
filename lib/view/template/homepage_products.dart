import 'package:flutter/material.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/organism/product_card.dart';
import 'package:handvibe/view/page/product_pages/my_product_detail.dart';
import 'package:handvibe/view/page/product_pages/product_detail.dart';
import 'package:provider/provider.dart';

class HomepageProducts extends StatefulWidget {
  final String myId;

  const HomepageProducts({super.key, required this.myId});

  @override
  State<HomepageProducts> createState() => _HomepageProductsState();
}

class _HomepageProductsState extends State<HomepageProducts> {
  int limit = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    Provider.of<ProductProvider>(context, listen: false).getProductsWithLimit(limit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          limit += 10;
          Provider.of<ProductProvider>(context, listen: false).getProductsWithLimit(limit);
        }
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, UserProvider>(builder: (context, productProvider, userProvider, widgets) {
      return Container(
        height: ScreenSizeUtil().getCalculateHeight(context, 550),
        margin: EdgeInsets.only(
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
          top: ScreenSizeUtil().getCalculateHeight(context, 20),
        ),
        child: GridView.builder(
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: productProvider.productsWithLimit.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCard(
              favoriteIconStatus: true,
              productModel: productProvider.productsWithLimit[index],
              onTap: () {
                if (widget.myId != productProvider.productsWithLimit[index].sellerId) {
                  UsefulMethods()
                      .navigatorPushMethod(context, ProductDetail(productModel: productProvider.productsWithLimit[index], myId: widget.myId));
                } else {
                  UsefulMethods()
                      .navigatorPushMethod(context, MyProductDetail(productModel: productProvider.productsWithLimit[index], myID: widget.myId));
                }
              },
              myProfile: userProvider.myProfile,
            );
          },
        ),
      );
    });
  }
}
