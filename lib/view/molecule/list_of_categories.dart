import 'package:flutter/material.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/provider/category_provider.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/category_button.dart';
import 'package:handvibe/view/page/product_pages/list_products_page.dart';
import 'package:provider/provider.dart';

class ListOfCategories extends StatefulWidget {
  final ProfileModel? myProfile;

  const ListOfCategories({super.key, required this.myProfile});

  @override
  State<ListOfCategories> createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoriesProvider, widgets) {
      return Container(
        margin: EdgeInsets.only(
          top: ScreenSizeUtil().getCalculateHeight(context, 10),
          left: ScreenSizeUtil().getCalculateWith(context, 10),
          right: ScreenSizeUtil().getCalculateWith(context, 10),
        ),
        height: ScreenSizeUtil().getCalculateHeight(context, 70),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesProvider.categories.length,
          itemBuilder: (context, index) {
            return categoriesProvider.categories[index].categoryNameEN == "Clothing & Accessories"
                ? CategoryButton(
                    path: ImageConstant().clothesIcon,
                    categoryModel: categoriesProvider.categories[index],
                    onTap: () {
                      UsefulMethods().navigatorPushMethod(
                        context,
                        ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                      );
                    },
                  )
                : categoriesProvider.categories[index].categoryNameEN == "Home & Decor"
                    ? CategoryButton(
                        path: ImageConstant().decorIcon,
                        categoryModel: categoriesProvider.categories[index],
                        onTap: () {
                          UsefulMethods().navigatorPushMethod(
                            context,
                            ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                          );
                        },
                      )
                    : categoriesProvider.categories[index].categoryNameEN == "Art & Crafts"
                        ? CategoryButton(
                            path: ImageConstant().craftIcon,
                            categoryModel: categoriesProvider.categories[index],
                            onTap: () {
                              UsefulMethods().navigatorPushMethod(
                                context,
                                ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                              );
                            },
                          )
                        : categoriesProvider.categories[index].categoryNameEN == "Personal Care & Cosmetics"
                            ? CategoryButton(
                                path: ImageConstant().cosmeticsIcon,
                                categoryModel: categoriesProvider.categories[index],
                                onTap: () {
                                  UsefulMethods().navigatorPushMethod(
                                    context,
                                    ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                                  );
                                },
                              )
                            : categoriesProvider.categories[index].categoryNameEN == "Baby & Kids"
                                ? CategoryButton(
                                    path: ImageConstant().kidsIcon,
                                    categoryModel: categoriesProvider.categories[index],
                                    onTap: () {
                                      UsefulMethods().navigatorPushMethod(
                                        context,
                                        ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                                      );
                                    },
                                  )
                                : categoriesProvider.categories[index].categoryNameEN == "Pet Accessories"
                                    ? CategoryButton(
                                        path: ImageConstant().petIcon,
                                        categoryModel: categoriesProvider.categories[index],
                                        onTap: () {
                                          UsefulMethods().navigatorPushMethod(
                                            context,
                                            ListProductsPage(categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                                          );
                                        },
                                      )
                                    : categoriesProvider.categories[index].categoryNameEN == "Eco-Friendly & Nature Products"
                                        ? CategoryButton(
                                            path: ImageConstant().natureIcon,
                                            categoryModel: categoriesProvider.categories[index],
                                            onTap: () {
                                              UsefulMethods().navigatorPushMethod(
                                                context,
                                                ListProductsPage(
                                                    categoryModel: categoriesProvider.categories[index], myProfile: widget.myProfile),
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.production_quantity_limits,
                                            color: ColorBank().white,
                                          );
          },
        ),
      );
    });
  }
}
