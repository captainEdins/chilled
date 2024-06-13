import 'package:flutter/material.dart';

import '../../resources/color.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorList.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust spacing as needed
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Center(child: botChatAI("Our Professional psychiatrists")),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1,
              ),
              communityBox(
                img: 'https://images.pexels.com/photos/6129203/pexels-photo-6129203.jpeg?auto=compress&cs=tinysrgb&w=600',
                doctorName: 'Dr. David Kagwi Wairoto',
                doctorTitle: 'Consultant Psychiatrist',
                phoneNumber: "+254769398128",
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1,
              ),
              communityBox(
                img: 'https://images.pexels.com/photos/3825457/pexels-photo-3825457.jpeg?auto=compress&cs=tinysrgb&w=600',
                doctorName: 'Dr. Lina Akello',
                doctorTitle: 'Consultant Psychiatrist',
                phoneNumber: "+25471029290",
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1,
              ),
              communityBox(
                img: 'https://images.pexels.com/photos/7579319/pexels-photo-7579319.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                doctorName: 'Dr. Linda N. Nyamute',
                doctorTitle: 'Consultant Psychiatrist',
                phoneNumber: "0737879077",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget botChatAI(String message) {
  return Text(message, style: TextStyle(color: ColorList.primary));
}

Widget communityBox({
  required String img,
  required String doctorName,
  required String doctorTitle,
  required String phoneNumber,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(img),
          radius: 30,
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(doctorTitle),
            SizedBox(height: 5),
            Text(phoneNumber),
          ],
        ),
      ],
    ),
  );
}
