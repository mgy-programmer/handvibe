import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handvibe/view/atom/nov_icon.dart';

class StreamIcon extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Function() onTap;
  final String text;
  final int index;
  final int selectedIndex;
  final String iconActivePath;
  final String iconPassivePath;

  const StreamIcon(
      {super.key,
      required this.stream,
      required this.onTap,
      required this.text,
      required this.index,
      required this.selectedIndex,
      required this.iconActivePath,
      required this.iconPassivePath});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Text('Error: ${asyncSnapshot.error}');
        }
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            final bool isSeen = asyncSnapshot.data!.docs.every((element) => element["isSeen"]);
            return NavIcon(
              onTap: onTap,
              iconActivePath: iconActivePath,
              iconPassivePath: iconPassivePath,
              text: text,
              selectedIndex: selectedIndex,
              index: index,
              isSeen: isSeen,
            );
        }
      },
    );
  }
}
