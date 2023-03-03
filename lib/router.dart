import 'package:flutter/material.dart';
import 'package:hola/features/auth/screens/login_screen.dart';
import 'package:hola/features/community/screens/community_screen.dart';
import 'package:hola/features/community/screens/create_community_screen.dart';
import 'package:hola/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

//loggedOutRoute
final loggedOutRoute = RouteMap(routes: {
  '/': (_) {
    return const MaterialPage(child: LoginScreen());
  }
});
//loggedInRoute
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/:name': (route) => MaterialPage(
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
});
