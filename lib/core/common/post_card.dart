import 'dart:developer';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hola/core/common/error_text.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/core/constants/constants.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';
import 'package:hola/features/community/controller/community_controller.dart';
import 'package:hola/features/post/controller/post_controller.dart';
import 'package:hola/models/post_model.dart';
import 'package:hola/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:video_player/video_player.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PostCardState();
  }
}

class _PostCardState extends ConsumerState<PostCard> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = true;

  void deletePost(WidgetRef ref, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Confirm Delete'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ref
                    .read(postControllerProvider.notifier)
                    .deletePost(widget.post, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(widget.post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(widget.post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: widget.post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${widget.post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/${widget.post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${widget.post.id}/comments');
  }

  void videoPlayPauseFn() {
    if (isPlaying) {
      _controller.pause();
      isPlaying = false;
    } else {
      _controller.play();
      isPlaying = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.post.type == 'image';
    final isTypeVideo = widget.post.type == 'video';
    final isTypeText = widget.post.type == 'text';
    final isTypeLink = widget.post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);

    if (isTypeVideo) {
      log('check if this the video link ${widget.post.link!}');

      _controller = VideoPlayerController.network(
        widget.post.link ??
            'https://www.pexels.com/video/a-close-up-video-of-table-hockey-6557767/',
      );
      _initializeVideoPlayerFuture = _controller.initialize();

      _controller.play();
    }

    return Card(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      )
                      // .copyWith(right: 0),
                      ,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.post.communityProfilePic,
                                      ),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.communityName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            widget.post.username,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          if (widget.post.awards.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.post.awards.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final award = widget.post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 23,
                                  );
                                },
                              ),
                            ),
                          ],
                          Text(
                            widget.post.title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                widget.post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeVideo)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    // If the VideoPlayerController has finished initialization, use
                                    // the data it provides to limit the aspect ratio of the video.
                                    return GestureDetector(
                                      onTap: videoPlayPauseFn,
                                      child: AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        // Use the VideoPlayer widget to display the video.
                                        child: VideoPlayer(_controller),
                                      ),
                                    );
                                  } else {
                                    // If the VideoPlayerController is still initializing, show a
                                    // loading spinner.
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          if (isTypeLink)
                            AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: widget.post.link!,
                            ),
                          if (isTypeText)
                            Text(widget.post.description!,
                                style: currentTheme.textTheme.bodyMedium),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // if (!kIsWeb)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        isGuest ? () {} : () => upvotePost(ref),
                                    icon: FaIcon(
                                      FontAwesomeIcons.circleUp,
                                      size: 30,
                                      color:
                                          widget.post.upvotes.contains(user.uid)
                                              ? Pallete.blueColor
                                              : null,
                                    ),
                                  ),
                                  Text(
                                    '${widget.post.upvotes.length - widget.post.downvotes.length == 0 ? 'Vote' : widget.post.upvotes.length - widget.post.downvotes.length == -1 ? '' : widget.post.upvotes.length - widget.post.downvotes.length}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {}
                                        : () => downvotePost(ref),
                                    icon: FaIcon(
                                      FontAwesomeIcons.circleDown,
                                      size: 30,
                                      color: widget.post.downvotes
                                              .contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      Icons.comment,
                                    ),
                                  ),
                                  Text(
                                    '${widget.post.commentCount == 0 ? 'Comment' : widget.post.commentCount}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      widget.post.communityName))
                                  .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          // onPressed: () {},
                                          icon: const Icon(
                                            Icons.admin_panel_settings,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                              IconButton(
                                onPressed: isGuest
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                ),
                                                itemCount: user.awards.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final award =
                                                      user.awards[index];

                                                  return GestureDetector(
                                                    onTap: () => awardPost(
                                                        ref, award, context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                          Constants
                                                              .awards[award]!),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.card_giftcard_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
