import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hola/core/common/error_text.dart';
import 'package:hola/core/common/loader.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';
import 'package:hola/models/user_model.dart';
import 'package:hola/router.dart';
import 'package:hola/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Hola',
          theme: Pallete.darkModeAppTheme,
          routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
            if (data != null) {
              getData(ref, data);
              if (userModel != null) {
                log('logged in Route');
                return loggedInRoute;
              }
            } else {
              return loggedOutRoute;
            }
            return loggedInRoute;
          }),
          routeInformationParser: const RoutemasterParser(),
        );
      },
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}
