import 'package:flutter/material.dart';
import 'package:hola/features/auth/screens/login_screen.dart';
import 'package:hola/features/community/screens/add_mods_screen.dart';
import 'package:hola/features/community/screens/community_screen.dart';
import 'package:hola/features/community/screens/create_community_screen.dart';
import 'package:hola/features/community/screens/edit_community_screen.dart';
import 'package:hola/features/community/screens/mod_tools_screen.dart';
import 'package:hola/features/home/screens/home_screen.dart';
import 'package:hola/features/payment/screens/payment_screen.dart';
import 'package:hola/features/post/screens/add_post_type_screen.dart';
import 'package:hola/features/post/screens/comments_screen.dart';
import 'package:hola/features/user_profile/screens/edit_profile_screen.dart';
import 'package:hola/features/user_profile/screens/user_profile_screen.dart';
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
  '/payment': (_) => const MaterialPage(
        child: PaymentScreen(),
      ),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(
          type: routeData.pathParameters['type']!,
        ),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentsScreen(
          postId: route.pathParameters['postId']!,
        ),
      ),
});
