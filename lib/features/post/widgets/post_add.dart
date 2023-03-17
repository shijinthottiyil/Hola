// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/theme/pallete.dart';

class PostAdd extends ConsumerWidget {
  final void Function()? onTapFn;
  final IconData icon;
  const PostAdd({super.key, required this.onTapFn, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return GestureDetector(
      onTap: onTapFn,
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: currentTheme.backgroundColor,
          elevation: 16,
          child: Center(
            child: Icon(
              icon,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
