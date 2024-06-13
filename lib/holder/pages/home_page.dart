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
  // variable to store username
  String username = "";

  // navigate to profilePage
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
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
    // Get username on initState
    getUsername();
  }

  Future<void> getUsername() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      // Get a reference to the user's document in Firestore
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          username = userData['username'] ?? ""; // Handle null username
        });
      }
    }
  }

  // Method to format date (assuming you want YYYY-MM-DD format)
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
        title: Text("Welcome to chilled"), // Set a title for your app
        backgroundColor: ColorList.primary, // Set the AppBar background color
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        // onSignOut: signOut,
      ),
      backgroundColor: ColorList.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    // spacing for the text and icon
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text for Appbar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi $username!", // Use username variable
                            style: TextStyle(
                              color: ColorList.lightGreyBest,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            formatDate(DateTime.now()), // Call formatDate method
                            style: TextStyle(color: ColorList.lightGreyBest),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: notch == 10 ? 38 : 70,
                        child: InkWell(
                          onTap: () {
                            // Handle icon click
                          },
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
                 
                  // search bar
                  InkWell(
                    onTap: () {
                      // Handle search bar click
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorList.lightGreyBest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          Text(
                            'Search',
                            style: TextStyle(color: ColorList.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25),
                  // how do you feel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "How do you feel",
                        style: TextStyle(
                          color: ColorList.lightGreyBest,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.more_horiz_outlined,
                          color: ColorList.lightGreyBest),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Four different Faces
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // runes for the faces
                      // bad
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '😂',
                          ),
                          SizedBox(height: 8),
                          Text('Bad',
                              style: TextStyle(color: ColorList.lightGreyBest)),
                        ],
                      ),

                      //fine

                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '😁',
                          ),
                          SizedBox(height: 8),
                          Text('Fine',
                              style: TextStyle(color: ColorList.lightGreyBest)),
                        ],
                      ),

                      // well
                      Column(
                        children: [
                          EmotionFace(
                            emojiconFace: '☺',
                          ),
                          SizedBox(height: 8),
                          Text('Well',
                              style: TextStyle(color: ColorList.lightGreyBest)),
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
                              color: ColorList.lightGreyBest,
                            ),
                          ),
                        ],
                      ),

                      // excellent
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            // Base Container
            
             Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                color: ColorList.primary,
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
                    // LISTVIEW OF EXERCISES
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle exercise tile click
                            },
                            child: ExerciseTile(
                              icon: Icons.favorite,
                              exerciseName: 'Speaking Skills',
                              numberOfExercises: 16,
                              color: Colors.orange,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle exercise tile click
                            },
                            child: ExerciseTile(
                              icon: Icons.person,
                              exerciseName: 'Reading Skills',
                              numberOfExercises: 8,
                              color: Colors.green,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle exercise tile click
                              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Message(), // Replace with your desired page
  ),
);
                              
                            },
                            child: ExerciseTile(
                              icon: Icons.star,
                              exerciseName: 'Writing Skills',
                              numberOfExercises: 16,
                              color: Colors.purple,
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
