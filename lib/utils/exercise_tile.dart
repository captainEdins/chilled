import 'package:flutter/material.dart';

import '../resources/color.dart';

class ExerciseTile extends StatelessWidget {

  final icon;
  final String exerciseName;
  final int numberOfExercises;
  final color;

  const ExerciseTile({Key? key,
  required this.icon,
  required this.exerciseName,
  required this.numberOfExercises,
  required this.color,

  }) : super(key :key );
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorList.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: color,
                  child: Icon(Icons.favorite, color: Colors.red[600]),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    exerciseName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    numberOfExercises.toString() + " Exercises",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                        
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.more_horiz),
        ]),
      ),
    );
  }
}
