// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/core/utils.dart';
import 'package:hola/features/community/controller/community_controller.dart';
import 'package:hola/features/post/controller/post_controller.dart';
import 'package:hola/features/post/widgets/post_textfield.dart';
import 'package:hola/models/community_model.dart';
import 'package:hola/theme/pallete.dart';

import '../../../core/common/error_text.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPostTypeScreenState();
  }
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  // Uint8List? bannerWebFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(
  //     'https://firebasestorage.googleapis.com/v0/b/hola-dfb23.appspot.com/o/posts%2Fcommnity_name%2Ff2ff63a0-c6e4-11ed-85c2-b9c26ff567c4?alt=media&token=8233fa5d-9b88-4cbb-b4e2-7bb5fc9a3426',
  //   );

  //   _initializeVideoPlayerFuture = _controller.initialize();
  //   _controller.setLooping(true);
  // }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    _controller.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      // if (kIsWeb) {
      //   setState(() {
      //     bannerWebFile = res.files.first.bytes;
      //   });
      // }
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectBannerVideo() async {
    final res = await pickVideo();

    if (res != null) {
      // if (kIsWeb) {
      //   setState(() {
      //     bannerWebFile = res.files.first.bytes;
      //   });
      // }
      setState(() {
        bannerFile = File(res.files.first.path!);
        _controller = VideoPlayerController.file(bannerFile!);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
            // webFile: bannerWebFile,
          );
    } else if (widget.type == 'video' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareVideoPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeVideo = widget.type == 'video';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 10),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      // onTap: () {},
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                ),
                          // const Center(
                          //   child: Icon(
                          //     Icons.camera_alt_outlined,
                          //     size: 40,
                          //   ),
                          // ),
                          // child: bannerWebFile != null
                          //     ? Image.memory(bannerWebFile!)
                          //     : bannerFile != null
                          //         ? Image.file(bannerFile!)
                          //         : const Center(
                          //             child: Icon(
                          //               Icons.camera_alt_outlined,
                          //               size: 40,
                          //             ),
                          //           ),
                        ),
                      ),
                    ),
                  if (isTypeVideo)
                    GestureDetector(
                      onTap: selectBannerVideo,
                      // onTap: () {},
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: bannerFile != null
                              ? FutureBuilder(
                                  future: _initializeVideoPlayerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      // If the VideoPlayerController has finished initialization, use
                                      // the data it provides to limit the aspect ratio of the video.
                                      return Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
                                            // Use the VideoPlayer widget to display the video.
                                            child: VideoPlayer(_controller),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Wrap the play or pause in a call to `setState`. This ensures the
                                              // correct icon is shown.
                                              setState(() {
                                                // If the video is playing, pause it.
                                                if (_controller
                                                    .value.isPlaying) {
                                                  _controller.pause();
                                                } else {
                                                  // If the video is paused, play it.
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            // Display the correct icon depending on the state of the player.
                                            icon: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      // If the VideoPlayerController is still initializing, show a
                                      // loading spinner.
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                )
                              : const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.video,
                                    size: 40,
                                  ),
                                ),
                          // const Center(
                          //   child: Icon(
                          //     Icons.camera_alt_outlined,
                          //     size: 40,
                          //   ),
                          // ),
                          // child: bannerWebFile != null
                          //     ? Image.memory(bannerWebFile!)
                          //     : bannerFile != null
                          //         ? Image.file(bannerFile!)
                          //         : const Center(
                          //             child: Icon(
                          //               Icons.camera_alt_outlined,
                          //               size: 40,
                          //             ),
                          //           ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    PostTextField(
                      textEditingController: descriptionController,
                      maxLines: 5,
                      hintText: 'Enter Description here',
                    ),
                  // TextField(
                  //   controller: descriptionController,
                  //   decoration: const InputDecoration(
                  //     filled: true,
                  //     hintText: 'Enter Description here',
                  //     border: InputBorder.none,
                  //     contentPadding: EdgeInsets.all(18),
                  //   ),
                  //   maxLines: 5,
                  // ),
                  if (isTypeLink)
                    PostTextField(
                      textEditingController: linkController,
                      hintText: 'Enter link here',
                    ),
                  // TextField(
                  //   controller: linkController,
                  //   decoration: const InputDecoration(
                  //     filled: true,
                  //     hintText: 'Enter link here',
                  //     border: InputBorder.none,
                  //     contentPadding: EdgeInsets.all(18),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Community',
                    ),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) {
                            return const SizedBox();
                          }

                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
    );
  }
}
