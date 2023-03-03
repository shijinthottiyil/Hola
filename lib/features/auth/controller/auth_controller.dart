import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/utils.dart';
import 'package:hola/features/auth/repository/auth_repository.dart';
import 'package:hola/models/user_model.dart';

final userProvider = StateProvider<UserModel?>(
  (ref) {
    return null;
  },
);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;
  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    //l means left and r means right//renamed r here to userModel
    user.fold((l) {
      return showSnackBar(context, l.message);
    }, (userModel) {
      _ref.read(userProvider.notifier).update((state) {
        return userModel;
      });
    });
  }
}
