import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final int? maxLines;
  final String hintText;
  const PostTextField({
    super.key,
    required this.textEditingController,
    this.maxLines,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(18),
      ),
      maxLines: maxLines,
    );
  }
}
