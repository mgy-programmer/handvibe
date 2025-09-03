import 'package:flutter/material.dart';
import 'package:handvibe/model/category_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/organism/show_products.dart';
import 'package:provider/provider.dart';

class ListProductsPage extends StatefulWidget {
  final CategoryModel categoryModel;
  final ProfileModel? myProfile;

  const ListProductsPage({super.key, required this.categoryModel, required this.myProfile});

  @override
  State<ListProductsPage> createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  int limit = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() {
    Provider.of<ProductProvider>(context, listen: false).getProductsByCategory(widget.categoryModel, limit);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.atEdge) {
          limit + 10;
          Provider.of<ProductProvider>(context, listen: false).getProductsByCategory(widget.categoryModel, limit);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.locale.languageCode == "en" ? widget.categoryModel.categoryNameEN : widget.categoryModel.categoryNameTR,
          style: TextFont().ralewayBoldMethod(18, ColorBank().secondaryText, context),
        ),
      ),
      body: Consumer<ProductProvider>(builder: (context, productProvider, widgets) {
        return ShowProducts(products: productProvider.productsByCategory, scrollController: scrollController, myProfile: widget.myProfile);
      }),
    );
  }
}
