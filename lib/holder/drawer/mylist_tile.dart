
import 'package:chilled/resources/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile({
    super.key, 
    required this.icon,
     required this.text,
     required this.onTap,
     });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: ColorList.secondary,
        ),
        onTap:onTap,
        title: Text(text,
        style: TextStyle(color: ColorList.white),
        ),
      ),
    );
  }
}