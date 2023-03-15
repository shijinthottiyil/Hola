import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/common/error_text.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/core/common/post_card.dart';
import 'package:hola/features/community/controller/community_controller.dart';
import 'package:hola/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider)!;
    // final isGuest = !user.isAuthenticated;

    return ref.watch(userCommunitiesProvider).when(
          data: (communities) => ref.watch(userPostsProvider(communities)).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );

    // return ref.watch(userCommunitiesProvider).when(
    //       data: (communities) => ref.watch(guestPostsProvider).when(
    //             data: (data) {
    //               return ListView.builder(
    //                 itemCount: data.length,
    //                 itemBuilder: (BuildContext context, int index) {
    //                   final post = data[index];
    //                   return PostCard(post: post);
    //                 },
    //               );
    //             },
    //             error: (error, stackTrace) {
    //               return ErrorText(
    //                 error: error.toString(),
    //               );
    //             },
    //             loading: () => const Loader(),
    //           ),
    //       error: (error, stackTrace) => ErrorText(
    //         error: error.toString(),
    //       ),
    //       loading: () => const Loader(),
    //     );
  }
}
