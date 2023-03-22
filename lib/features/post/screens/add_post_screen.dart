// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hola/core/utils.dart';
import 'package:hola/features/post/widgets/post_add.dart';
import 'package:hola/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double cardHeightWidth = 120;
    // double iconSize = 60;
    // final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PostAdd(
                onTapFn: () => navigateToType(context, 'image'),
                icon: Icons.image_outlined,
              ),
              PostAdd(
                onTapFn: () => navigateToType(context, 'text'),
                icon: Icons.font_download_outlined,
              ),
              PostAdd(
                onTapFn: () => navigateToType(context, 'link'),
                icon: Icons.link_outlined,
              ),

              // GestureDetector(
              //   onTap: () => navigateToType(context, 'image'),
              //   child: SizedBox(
              //     height: cardHeightWidth,
              //     width: cardHeightWidth,
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       color: currentTheme.backgroundColor,
              //       elevation: 16,
              //       child: Center(
              //         child: Icon(
              //           Icons.image_outlined,
              //           size: iconSize,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () => navigateToType(context, 'text'),
              //   child: SizedBox(
              //     height: cardHeightWidth,
              //     width: cardHeightWidth,
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       color: currentTheme.backgroundColor,
              //       elevation: 16,
              //       child: Center(
              //         child: Icon(
              //           Icons.font_download_outlined,
              //           size: iconSize,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () => navigateToType(context, 'link'),
              //   child: SizedBox(
              //     height: cardHeightWidth,
              //     width: cardHeightWidth,
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       color: currentTheme.backgroundColor,
              //       elevation: 16,
              //       child: Center(
              //         child: Icon(
              //           Icons.link_outlined,
              //           size: iconSize,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          PostAdd(
            onTapFn: () => navigateToType(context, 'video'),
            // onTapFn: () {
            //   pickVideo();
            // },
            icon: FontAwesomeIcons.video,
          ),
        ],
      ),
    );
  }
}
