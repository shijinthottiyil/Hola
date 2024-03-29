import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
        communityNameController.text.trim().replaceAll(' ', '_'), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create a community'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Create community')),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: communityNameController,
                      decoration: const InputDecoration(
                        hintText: 'Community_name',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 21,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: createCommunity,
                      // onPressed: () {
                      //   log(communityNameController.text
                      //       .trim()
                      //       .replaceAll(' ', ''));
                      // },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Text(
                        "Create community",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
