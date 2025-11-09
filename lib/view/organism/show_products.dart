import 'package:flutter/material.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/organism/product_card.dart';
import 'package:handvibe/view/page/product_pages/product_detail.dart';

class ShowProducts extends StatelessWidget {
  final List<ProductModel> products;
  final ScrollController scrollController;
  final ProfileModel? myProfile;
  final bool favoriteIconStatus;

  const ShowProducts({super.key, required this.products, required this.scrollController, required this.myProfile, this.favoriteIconStatus = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSizeUtil().getCalculateHeight(context, 700),
      margin: EdgeInsets.only(
        left: ScreenSizeUtil().getCalculateWith(context, 10),
        right: ScreenSizeUtil().getCalculateWith(context, 10),
      ),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            productModel: products[index],
            favoriteIconStatus: favoriteIconStatus,
            onTap: () {
              UsefulMethods().navigatorPushMethod(
                context,
                ProductDetail(productModel: products[index], myId: myProfile != null ? myProfile!.profileId : ""),
              );
            },
            myProfile: myProfile,
          );
        },
      ),
    );
  }
}
