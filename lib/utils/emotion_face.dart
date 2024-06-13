import 'package:chilled/resources/color.dart';
import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
  final String emojiconFace;
  const EmotionFace({
    required this.emojiconFace,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorList.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          emojiconFace,
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
