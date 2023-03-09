import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hola/core/constants/constants.dart';
import 'package:hola/core/failure.dart';
import 'package:hola/core/providers/storage_repository_provider.dart';
import 'package:hola/core/utils.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';
import 'package:hola/features/community/repository/community_repository.dart';
import 'package:hola/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

//Streamprovider.family is used becuase we have to accept a parameter from the fun. because of that purpose we use family

final serachCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(
    Community community,
    BuildContext context,
  ) async {
    // this is the function for both joining community and leaving from community
    // by writing like this we don't need to write two separate fun. for joining and leaving community
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      // here we are checking if the user is already part of the community
      //if user is part of the community then we will remove him from the community
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      // the else part means the user is not the part of the community ie, the user wants to join the community
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    //res.fold  is used to check whether there are any error or something like that
    res.fold(
        (l) => showSnackBar(
              context,
              l.toString(),
            ), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'Community left Successfully');
      } else {
        showSnackBar(context, 'Community Joined Successfully');
      }
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null) {
      //the file stores like communites/profile/name(id) or name of the community
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      //the file stores like communites/banner/name(id)or name of the community
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.toString()),
        (r) => community = community.copyWith(banner: r),
      );
    }
    //the line below will exceute after the if conditions. if the user does not change anything then also this line gets executed.

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.toString()),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
