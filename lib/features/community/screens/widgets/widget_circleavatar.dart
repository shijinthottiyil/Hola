import 'package:flutter/material.dart';

class WidgetCircleAvatar extends StatelessWidget {
  final ImageProvider<Object>? profileImage;

  const WidgetCircleAvatar({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return CircleAvatar(
      backgroundImage: profileImage,
      radius: height / 26,
    );
  }
}
