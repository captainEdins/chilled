import 'package:chilled/holder/pages/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chilled/holder/drawer/drawer.dart';
import 'package:chilled/holder/pages/profile_page.dart';
import 'package:chilled/resources/color.dart';
import 'package:chilled/utils/emotion_face.dart';
import 'package:chilled/utils/exercise_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = "";

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  Future<void> getFullName() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          fullName = userData['full_name'] ?? "";
        });
      }
    }
  }

  String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    var notch = 10.0;
    if (MediaQuery.of(context).viewPadding.top > 0) {
      notch = 40.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to chilled",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20 ),
        ),
        iconTheme: IconThemeData(color: ColorList.secondary), // Set icon color to white
        backgroundColor: ColorList.black,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white, // Set drawer background color to white
          // Adjust text color to ensure readability on white background
          primaryColor: Colors.black, // Change text color to black
        ),
        child: Material(
          elevation: 16, // Add elevation to the drawer
          child: MyDrawer(
            onProfileTap: goToProfilePage,
          ),
        ),
      ),
      backgroundColor: ColorList.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi $fullName!",
                            style: TextStyle(
                              color: ColorList.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            formatDate(DateTime.now()),
                            style: TextStyle(color: ColorList.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: notch == 10 ? 38 : 70,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorList.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.notifications, color: ColorList.secondary),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorList.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(color: ColorList.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "How do you feel",
                        style: TextStyle(
                          color: ColorList.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.more_horiz_outlined,
                          color: ColorList.white),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace:'😥',
                          ),
                          SizedBox(height: 8),
                          Text('Bad',
                              style: TextStyle(color: ColorList.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '😁',
                          ),
                          SizedBox(height: 8),
                          Text('Fine',
                              style: TextStyle(color: ColorList.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '😊',
                          ),
                          SizedBox(height: 8),
                          Text('Well',
                              style: TextStyle(color: ColorList.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '😋',
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Excellent ',
                            style: TextStyle(
                              color: ColorList.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                color: ColorList.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Exercises",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Icon(Icons.more),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: ExerciseTile(
                              icon: Icons.favorite,
                              exerciseName: 'Speaking Skills',
                              numberOfExercises: 16,
                              color: Colors.orange,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: ExerciseTile(
                              icon: Icons.person,
                              exerciseName: 'Reading Skills',
                              numberOfExercises: 8,
                              color: Colors.green,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            },
                            child: ExerciseTile(
                              icon: Icons.star,
                              exerciseName: 'Writing Skills',
                              numberOfExercises: 16,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
