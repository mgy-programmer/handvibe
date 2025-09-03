import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/molecule/double_option.dart';
import 'package:handvibe/view/organism/show_products.dart';
import 'package:provider/provider.dart';

class MyAdsList extends StatefulWidget {
  final ProfileModel myProfile;

  const MyAdsList({super.key, required this.myProfile});

  @override
  State<MyAdsList> createState() => _MyAdsListState();
}

class _MyAdsListState extends State<MyAdsList> {
  ScrollController scrollController = ScrollController();
  int limit = 10;
  int selectedIndex = 0;

  @override
  void initState() {
    fillDataSeller();
    super.initState();
  }

  fillDataSeller() async {
    Provider.of<ProductProvider>(context, listen: false).getProductsBySeller(widget.myProfile.profileId, limit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          limit += 10;
          Provider.of<ProductProvider>(context, listen: false).getProductsBySeller(widget.myProfile.profileId, limit);
        }
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, UserProvider>(builder: (context, productProvider, userProvider, widgets) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
              ),
              child: DoubleOption(
                index: selectedIndex,
                returnedIndex: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  if (selectedIndex == 1) {
                    Provider.of<ProductProvider>(context, listen: false).getProductsFavorite(widget.myProfile.savedProducts);
                  }
                },
              ),
            ),
            selectedIndex == 0
                ? ShowProducts(
                    products: productProvider.productsBySeller,
                    scrollController: scrollController,
                    myProfile: userProvider.myProfile,
                    favoriteIconStatus: false,
                  )
                : ShowProducts(
                    products: productProvider.productsFavorite,
                    scrollController: scrollController,
                    myProfile: userProvider.myProfile,
                  ),
          ],
        ),
      );
    });
  }
}
