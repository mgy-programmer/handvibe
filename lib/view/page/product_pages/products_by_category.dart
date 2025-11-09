import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/shared_preferences.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/organism/show_products.dart';
import 'package:provider/provider.dart';

class ProductsByCategory extends StatefulWidget {
  final CategoryModel category;

  const ProductsByCategory({super.key, required this.category});

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  int limit = 10;
  ScrollController scrollController = ScrollController();
  String myID = "";

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    Provider.of<ProductProvider>(context, listen: false).getProductsByCategory(widget.category, limit);
    myID = await SharedPreferencesMethods().getUserID();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          limit += 10;
          Provider.of<ProductProvider>(context, listen: false).getProductsByCategory(widget.category, limit);
        }
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.categoryNameTR),
      ),
      body: Consumer2<ProductProvider, UserProvider>(builder: (context, productProvider, userProvider, widgets) {
        return productProvider.progressing != Progressing.busy
            ? ShowProducts(products: productProvider.productsByCategory, scrollController: scrollController, myProfile: userProvider.myProfile)
            : Center(
                child: LoadingWidget(),
              );
      }),
    );
  }
}
