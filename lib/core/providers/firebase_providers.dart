import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final authProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final storageProvider = Provider((ref) {
  return FirebaseStorage.instance;
});

final googleSignInProvider = Provider((ref) {
  return GoogleSignIn();
});
