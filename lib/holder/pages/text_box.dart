import 'package:chilled/resources/color.dart';
import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: ColorList.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.only(left: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // sectionName
              children: [
                Text(sectionName, style: TextStyle(color: ColorList.primary)),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.settings, color: ColorList.secondary),
                )
              ],
            ),

            // text
            Text(text, style: TextStyle(color: ColorList.black)),
          ],
        ));
  }
}
