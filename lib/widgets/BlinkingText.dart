import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlinkingTextAnimation extends StatefulWidget {
  var text, duration = 500;
  double fontSize = 28;
      BlinkingTextAnimation(this.text, {this.duration, this.fontSize});

  @override
  _BlinkingAnimationState createState() => _BlinkingAnimationState();
}

class _BlinkingAnimationState extends State<BlinkingTextAnimation>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;

  initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration??500), vsync: this);

    final CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Curves.ease);

    animation =
        ColorTween(begin: Colors.white, end: Colors.red).animate(curve);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return new Container(
            child: Text(widget.text,
                style: TextStyle(color: animation.value, fontSize: widget.fontSize)),
          );
        });
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}