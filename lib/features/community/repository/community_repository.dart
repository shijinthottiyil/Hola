import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hola/core/constants/firebase_constants.dart';
import 'package:hola/core/failure.dart';
import 'package:hola/core/providers/firebase_providers.dart';
import 'package:hola/core/type_defs.dart';
import 'package:hola/models/community_model.dart';
import 'package:hola/models/post_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CollectionReference get _posts {
    return _firestore.collection(FirebaseConstants.postsCollection);
  }

  CollectionReference get _communities {
    return _firestore.collection(FirebaseConstants.communitiesCollection);
  }

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureEither<void> createCommunity(Community community) async {
    //Create Community is the Fn to create a community
    //This is a FutureEither fn. Which means on success void is returned and on failure Failure class is returned

    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //joinCommunity fn and the leaveCommunity fn are the fn. for joining and  removing from the community

  FutureEither<void> joinCommunity(
    String communityName,
    String userId,
  ) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayUnion([
            userId
          ]), //FieldValue.arrayUnion is the fn provided  by firebase to update the values in firestore
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> leaveCommunity(
    String communityName,
    String userId,
  ) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayRemove([
            userId
          ]), //FieldValue.arrayRemove is the fn provided  by firebase to remove the values in firestore
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) {
      return Community.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  //fun for sending image to firebase storage and linking it in the firestore

  FutureEither<void> editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //searchCommunity fn. is for the searching part using SearchDelegate
  /*query.isEmpty? we are checking this condition because if we dont check this condition the entire will show that we don want*/

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
      List<Community> communites = [];
      for (var community in event.docs) {
        communites.add(
          Community.fromMap(community.data() as Map<String, dynamic>),
        );
      }
      return communites;
    });
  }

  FutureEither<void> addMods(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'mods': uids,
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
