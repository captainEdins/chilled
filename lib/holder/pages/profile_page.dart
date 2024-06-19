import 'package:chilled/holder/pages/text_box.dart';
import 'package:chilled/resources/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> editField(String field, String newValue) async {
    await _firestore.collection('users').doc(currentUser.uid).update({
      field: newValue,
    });
    setState(() {
      _fullNameController.text = newValue;
    });
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
          GestureDetector(
            onTap: () async {
              String? newName = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Change Full Name"),
                    content: TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(hintText: "Enter new full name"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          String? newName = _fullNameController.text.trim();
                          Navigator.pop(context, newName);
                        },
                        child: Text("Save"),
                      ),
                    ],
                  );
                },
              );

              if (newName != null) {
                await editField('full_name', newName);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorList.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.edit,
                  size: 24,
                  color: ColorList.secondary,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorList.primary),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'User Details',
              style: TextStyle(color: ColorList.primary),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('users').doc(currentUser.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>?;

              return Column(
                children: [
                  MyTextBox(
                    text: userData?['full_name'] ?? 'N/A',
                    sectionName: 'Full Name',
                    onPressed: () => editField('full_name', _fullNameController.text),
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
