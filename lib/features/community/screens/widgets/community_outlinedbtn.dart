import 'package:flutter/material.dart';

class CommunityOutlinedbtn extends StatelessWidget {
  final void Function()? buttonFunction;
  final Widget? buttonName;
  const CommunityOutlinedbtn({
    super.key,
    required this.buttonFunction,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: buttonFunction,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
      ),
      child: buttonName,
    );
  }
}
