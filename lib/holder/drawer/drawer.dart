import 'package:chilled/holder/drawer/mylist_tile.dart';
import 'package:chilled/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../authentication/login.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyDrawer({
    Key? key,
    required this.onProfileTap,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pop(context); // Close the drawer
     Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => Login()),
  (route) => false, // Removes all routes
);
    } catch (e) {
      print("Error signing out: $e");
      // If an error occurs during navigation, print the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorList.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: ColorList.secondary,
                  size: 64,
                ),
              ),

              // Home
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              // Profile
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I  L E',
                onTap: onProfileTap,
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: () => _signOut(context),
            ),
          ),
        ],
      ),
    );
  }
}
