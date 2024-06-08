
import 'package:chilled/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class DialogLoadWait extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient:  LinearGradient(
                        colors: [
                          ColorList.primary,
                          ColorList.primary.withOpacity(0.4),
                        ]
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    children: [
                      Text("Almost There",style: TextStyle(
                        color: ColorList.white,
                        fontWeight: FontWeight.w900,
                      ),),
                      Text("you will be connected",style: TextStyle(
                        color: ColorList.white,
                      ),),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: - 50,
                  child: CircleAvatar(
                      backgroundColor: ColorList.white,
                      radius: 50,
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: ColorList.primary,
                        size: 200,
                      ),
                  )
              )
            ],
          ),
        );
      }

    }
