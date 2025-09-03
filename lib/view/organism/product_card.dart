import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handvibe/model/product_model.dart';
import 'package:handvibe/model/profile_model.dart';
import 'package:handvibe/model_view/firebase/firebase_user.dart';
import 'package:handvibe/model_view/provider/user_provider.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/constant.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/view/page/login_pages/login_page.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel productModel;
  final ProfileModel? myProfile;
  final Function() onTap;
  final bool favoriteIconStatus;

  const ProductCard({super.key, required this.productModel, required this.onTap, required this.myProfile, required this.favoriteIconStatus});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<String> favoriteList = [];

  @override
  void initState() {
    if (widget.myProfile != null) {
      favoriteList = widget.myProfile!.savedProducts;
    }
    super.initState();
  }

  fillData() async {
    Provider.of<UserProvider>(context, listen: false).getMyProfile(widget.myProfile!.profileId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(widget.productModel.productImages.first.mediaPath),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            widget.myProfile != null && widget.productModel.sellerId != widget.myProfile!.profileId
                ? widget.favoriteIconStatus
                    ? Align(
                        alignment: Alignment(1, -1),
                        child: IconButton(
                          onPressed: () async {
                            if (widget.myProfile != null) {
                              if (favoriteList.contains(widget.productModel.productId)) {
                                favoriteList.remove(widget.productModel.productId);
                              } else {
                                favoriteList.add(widget.productModel.productId);
                              }
                              await FireStoreUser().updateSavedProducts(widget.myProfile!.profileId, favoriteList);
                              fillData();
                            } else {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => LoginPage(),
                              );
                            }
                          },
                          icon: SvgPicture.asset(
                            favoriteList.contains(widget.productModel.productId) ? ImageConstant().saveActiveIcon : ImageConstant().saveIcon,
                          ),
                        ),
                      )
                    : Container()
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorBank().white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2), // Hafif gölge
                      blurRadius: 8, // Gölgenin yayılma oranı
                      spreadRadius: 2, // Gölgenin genişliği
                      offset: const Offset(0, 4), // Gölgenin konumu (X, Y)
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: ScreenSizeUtil().getCalculateWith(context, 10),
                  right: ScreenSizeUtil().getCalculateWith(context, 10),
                  top: ScreenSizeUtil().getCalculateHeight(context, 10),
                  bottom: ScreenSizeUtil().getCalculateHeight(context, 10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.productModel.productName,
                      style: TextFont().ralewayRegularMethod(16, ColorBank().black, context),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${widget.productModel.price} ${widget.productModel.currency}",
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
    );
  }
}
