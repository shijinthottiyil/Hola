import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hola/features/auth/controller/auth_controller.dart';
import 'package:hola/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void navigateToPaymentScreen(BuildContext context) {
    Routemaster.of(context).push('/payment');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!; //to get the user details
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => navigateToUserProfile(context, user.uid),
              child: SizedBox(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 70,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
            ListTile(
              title: const Text('Contribute'),
              leading: const FaIcon(FontAwesomeIcons.handHoldingDollar),
              onTap: () => navigateToPaymentScreen(context),
            ),
            Row(
              children: [
                Switch.adaptive(
                  inactiveTrackColor: Colors.amber,
                  value: ref.watch(themeNotifierProvider.notifier).mode ==
                      ThemeMode.dark,
                  onChanged: (value) => toggleTheme(ref),
                ),
                const SizedBox(
                  width: 13,
                ),
                Text(
                  ref.watch(themeNotifierProvider.notifier).mode ==
                          ThemeMode.dark
                      ? 'Light Mode'
                      : 'Dark Mode',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
