import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/core/common/sign_in_button.dart';
import 'package:hola/core/constants/constants.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: height / 10,
        ),
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: height / 25,
                ),
                const Text(
                  'Dive into anything',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  height: height / 25,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        'HOLA!',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 10,
                        ),
                      ),
                    ),
                  ),
                  // child: Image.asset(
                  //   Constants.loginEmotePath,
                  //   height: 400,
                  // ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                const SignInButton(),
              ],
            ),
    );
  }
}
