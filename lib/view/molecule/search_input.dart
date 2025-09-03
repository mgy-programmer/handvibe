import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final Widget icon;
  final Function(String) onChanged;
  final double width;
  const SearchInput({super.key, required this.searchController, required this.hintText, required this.icon, required this.onChanged, this.width = 270});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSizeUtil().getCalculateWith(context, width),
      padding: EdgeInsets.only(
        left: ScreenSizeUtil().getCalculateWith(context, 10),
        right: ScreenSizeUtil().getCalculateWith(context, 10),
      ),
      decoration: BoxDecoration(
        color: ColorBank().white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: icon,
        ),
      ),
    );
  }
}
