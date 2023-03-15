import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hola/core/constants/firebase_constants.dart';
import 'package:hola/core/failure.dart';
import 'package:hola/core/providers/firebase_providers.dart';
import 'package:hola/core/type_defs.dart';
import 'package:hola/models/user_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Stream<List<Post>> getUserPosts(String uid) {
  //   return _posts.where('uid', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots().map(
  //         (event) => event.docs
  //             .map(
  //               (e) => Post.fromMap(
  //                 e.data() as Map<String, dynamic>,
  //               ),
  //             )
  //             .toList(),
  //       );
  // }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
