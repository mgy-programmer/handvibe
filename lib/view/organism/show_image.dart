import 'package:flutter/material.dart';
import 'package:handvibe/model/media_hide_model.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/view/molecule/smoth_indicator.dart';

class ShowImage extends StatefulWidget {
  final List<MediaHideModel> images;

  const ShowImage({super.key, required this.images});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  int scrollingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSizeUtil().getCalculateHeight(context, 300),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: PageView.builder(
              itemCount: widget.images.length,
              onPageChanged: (value) {
                setState(() {
                  scrollingIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index].mediaPath,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              margin: EdgeInsets.only(
                bottom: ScreenSizeUtil().getCalculateHeight(context, 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => SmoothIndicator(
                    scrollingIndex: scrollingIndex,
                    index: index,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
