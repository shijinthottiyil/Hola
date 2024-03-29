import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/common/error_text.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/core/constants/constants.dart';
import 'package:hola/core/utils.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';
import 'package:hola/features/community/controller/community_controller.dart';
import 'package:hola/features/community/screens/widgets/widget_circleavatar.dart';
import 'package:hola/features/user_profile/repositrory/user_profile_repository.dart';
import 'package:hola/models/community_model.dart';
import 'package:hola/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name; //to get the name of the community we are working on
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final height = MediaQuery.of(context).size.height;

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            // ignore: deprecated_member_use
            backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 4.2,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: height / 5.7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileFile != null
                                        ? WidgetCircleAvatar(
                                            profileImage:
                                                FileImage(profileFile!),
                                          )
                                        // CircleAvatar(
                                        //     backgroundImage:
                                        //         FileImage(profileFile!),
                                        //     radius: height / 26,
                                        //   )
                                        : WidgetCircleAvatar(
                                            profileImage:
                                                NetworkImage(community.avatar),
                                          )
                                    // CircleAvatar(
                                    //     backgroundImage:
                                    //         NetworkImage(community.avatar),
                                    //     radius: height / 26,
                                    //   ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
