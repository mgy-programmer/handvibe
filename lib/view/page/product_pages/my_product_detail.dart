import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model_view/firebase/firebase_product.dart';
import 'package:handvibe/model_view/firebase/firebase_storage.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/product_provider.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/model_view/services/language_localizations.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/enum.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/loading_widget.dart';
import 'package:handvibe/view/organism/show_image.dart';
import 'package:handvibe/view/organism/show_similar_product.dart';
import 'package:handvibe/view/page/product_pages/products_by_category.dart';
import 'package:handvibe/view/template/question_dialog.dart';
import 'package:provider/provider.dart';

class MyProductDetail extends StatefulWidget {
  final String myID;
  final ProductModel productModel;

  const MyProductDetail({super.key, required this.myID, required this.productModel});

  @override
  State<MyProductDetail> createState() => _MyProductDetailState();
}

class _MyProductDetailState extends State<MyProductDetail> {
  bool follow = false;
  bool showAll = false;
  List<String> products = [];
  Progressing progressing = Progressing.idle;

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getProductsByCategoryList(widget.productModel.productCategoryList, 5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, widgets) {
      return Scaffold(
        backgroundColor: ColorBank().background,
        appBar: AppBar(
          title: Text(
            widget.productModel.productName,
            style: TextFont().ralewayRegularMethod(18, ColorBank().black, context),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => QuestionDialog(
                    content: AppLocalizations.of(context)!.translate("are_you_sure"),
                    yesMethod: progressing != Progressing.busy
                        ? () async {
                            if (progressing != Progressing.busy) {
                              setState(() {
                                progressing = Progressing.busy;
                              });
                              for (var i in widget.productModel.productImages) {
                                await FirebaseStorageMethods().deleteFileFromFirebaseStorage(i.mediaName, Constants().products);
                              }
                              await FirebaseProduct().deleteProduct(widget.productModel.productId);
                              if (context.mounted) {
                                Provider.of<ProductProvider>(context, listen: false).getProductsWithLimit(10);
                                products = userProvider.myProfile!.products;
                                products.remove(widget.productModel.productId);
                                await FireStoreUser().updateProducts(widget.productModel.sellerId, products);
                                if (context.mounted) Navigator.pop(context);
                              }
                              setState(() {
                                progressing = Progressing.idle;
                              });
                            }
                          }
                        : () {},
                    progressing: progressing,
                  ),
                );
              },
              icon: SvgPicture.asset(
                ImageConstant().trashRedIcon,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShowImage(images: widget.productModel.productImages),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: ScreenSizeUtil().getCalculateWith(context, 10),
                      right: ScreenSizeUtil().getCalculateWith(context, 10),
                      top: ScreenSizeUtil().getCalculateHeight(context, 20),
                      bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showAll = !showAll;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
                            ),
                            child: Text(
                              widget.productModel.description,
                              style: TextFont().ralewayRegularMethod(16, ColorBank().black, context),
                              textAlign: TextAlign.left,
                              maxLines: showAll ? 2 : 30,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: ScreenSizeUtil().getCalculateWith(context, 3),
                          runSpacing: ScreenSizeUtil().getCalculateHeight(context, 3),
                          children: List.generate(
                            widget.productModel.productCategoryList.length,
                            (index) => GestureDetector(
                              onTap: () {
                                UsefulMethods().navigatorPushMethod(context, ProductsByCategory(category: widget.productModel.productCategoryList[index]));
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: ScreenSizeUtil().getCalculateWith(context, 10),
                                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                                  top: ScreenSizeUtil().getCalculateHeight(context, 5),
                                  bottom: ScreenSizeUtil().getCalculateHeight(context, 5),
                                ),
                                decoration: BoxDecoration(
                                  color: ColorBank().primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.productModel.productCategoryList[index].categoryNameTR,
                                  style: TextFont().ralewayRegularMethod(16, ColorBank().white, context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ShowSimilarProduct(productModel: widget.productModel, myId: widget.myID),
                ],
              ),
            ),
            progressing != Progressing.idle
                ? Align(
                    alignment: Alignment.center,
                    child: LoadingWidget(),
                  )
                : Container()
          ],
        ),
      );
    });
  }
}
