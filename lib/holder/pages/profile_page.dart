import 'package:chilled/holder/pages/text_box.dart';
import 'package:chilled/resources/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> editField(String field) async {
    // Implement field editing logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Profile",
            style: TextStyle(color: ColorList.primary),
          ),
        ),
        backgroundColor: ColorList.white,
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),
          Icon(
            Icons.person,
            size: 72,
            color: ColorList.secondary,
          ),
          SizedBox(height: 10),
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorList.primary),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'User Details',
              style: TextStyle(color: ColorList.primary),
            ),
          ),
          MyTextBox(
            text: 'user',
            sectionName: 'username',
            onPressed: () => editField('username'),
          ),
          // Display additional user information from Firestore
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('users').doc(currentUser.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              // Access user data from Firestore
              var userData = snapshot.data!.data() as Map<String, dynamic>?;

              return Column(
                children: [
                  // Example displaying user's full name
                  Text(
                    'Full Name: ${userData?['full_name'] ?? 'N/A'}',
                    style: TextStyle(color: ColorList.primary),
                  ),
                  // Add more fields as needed
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
