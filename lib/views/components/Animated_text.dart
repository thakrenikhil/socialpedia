import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final Color? color;
  const AnimatedText(this.color,{super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: DefaultTextStyle(
        style:  TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: color),
        child: AnimatedTextKit(displayFullTextOnTap: true,
          animatedTexts: [
            TyperAnimatedText(text,speed: const Duration(milliseconds: 300),),
          ],
        ),
      ),
    );
  }
}