import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:image_picker/image_picker.dart';

class SellProductImageList extends StatefulWidget {
  final List<XFile> selectedImages;
  final Function(List<XFile>) returnedList;

  const SellProductImageList({super.key, required this.selectedImages, required this.returnedList});

  @override
  State<SellProductImageList> createState() => _SellProductImageListState();
}

class _SellProductImageListState extends State<SellProductImageList> {
  List<XFile> selectedImage = [];

  @override
  void initState() {
    selectedImage = widget.selectedImages;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenSizeUtil().getCalculateHeight(context, 100),
      margin: EdgeInsets.only(
        top: ScreenSizeUtil().getCalculateHeight(context, 10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.builder(
              itemCount: selectedImage.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: ScreenSizeUtil().getCalculateWith(context, 150),
                  height: ScreenSizeUtil().getCalculateWith(context, 100),
                  child: Stack(
                    children: [
                      Container(
                        width: ScreenSizeUtil().getCalculateWith(context, 150),
                        height: ScreenSizeUtil().getCalculateWith(context, 100),
                        margin: EdgeInsets.only(
                          right: ScreenSizeUtil().getCalculateWith(context, 5),
                          left: ScreenSizeUtil().getCalculateWith(context, 5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedImage[index].path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(1, -1),
                        child: IconButton(
                          onPressed: () {
                            selectedImage.remove(selectedImage[index]);
                            setState(() {

                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: ColorBank().white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () async {
                selectedImage = await ImagePicker().pickMultiImage();
                setState(() {});
              },
              child: Container(
                width: ScreenSizeUtil().getCalculateWith(context, 150),
                height: ScreenSizeUtil().getCalculateWith(context, 100),
                margin: EdgeInsets.only(
                  right: ScreenSizeUtil().getCalculateWith(context, 5),
                  left: ScreenSizeUtil().getCalculateWith(context, 5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorBank().primary,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: ColorBank().white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
