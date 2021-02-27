import 'dart:math';
import 'package:clockly/widgets/BlinkingText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';


class TimerView extends StatefulWidget {
  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> with AutomaticKeepAliveClientMixin<TimerView>{
  var buttonState = "Start";
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  String millisecondsStr = '00';
  String text="000000";
  int timefortimer = 0;
  bool isStarted = false, isTimerPlaying = false;

  _onKeyboardTap(String value) {
    if(text.length<=11){
      setState(() {
        text = text+value;
      });
    }
    toDisplay();
    print(text);
  }

  toDisplay(){
    if(text.length>5){
      isStarted=true;
      secondsStr = text.length>0?text.substring(text.length-2):"00";
      minutesStr = text.length>0?text.substring(text.length-4, text.length-2):"00";
      hoursStr = text.length>5?text.substring(text.length-6, text.length-4):"00";
    }
    else if(text.length<=5) setState(() {
      isStarted = false;
    });
  }

  _color(){
    if(isStarted)return Colors.black87;
        else return Colors.grey;
  }

  void startTimer(){
    setState(() {
      isTimerPlaying = true;
    });
    timefortimer = int.parse(hoursStr)*3600 + int.parse(minutesStr)*60 + int.parse(secondsStr);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new CountDown(timefortimer)));
    print("Timer set at $timefortimer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: //isTimerPlaying? CountDown(timefortimer):
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Text("$hoursStr", style: TextStyle(fontSize: 60.0, color: _color()),),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("h", style: TextStyle(fontSize: 20.0, color: _color()),textAlign: TextAlign.end,),
                  ),
                  Text(" $minutesStr", style: TextStyle(fontSize: 60.0, color: _color()),),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("m", style: TextStyle(fontSize: 20.0, color: _color()),),
                    ),
                  Text(" $secondsStr", style: TextStyle(fontSize: 60.0, color: _color()),),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("s", style: TextStyle(fontSize: 20.0, color: _color()),),
                    ),
                ],)
              ),
              NumericKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  textColor:  _textColor(context),

                  rightButtonFn: () {
                    setState(() {
                      if(text.length>5) text = text.substring(0, text.length - 1);
                      print(text);
                      toDisplay();
                    });
                  },
                  rightIcon: Icon(Icons.backspace, color: Colors.red,),

                  // leftButtonFn: () {
                  //   print('left button clicked');
                  // },
                  // leftIcon: Icon(Icons.check, color: Colors.green,),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ),

              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: isStarted?Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 45,
                      child: NeumorphicButton(
                          onPressed: () => startTimer(),
                          style: NeumorphicStyle(
                            //color: isStarted?Colors.greenAccent:Colors.white,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.circle()
                          ),
                          child: Icon(Icons.play_arrow)
                      ),
                    ),
                  ],):Center()
              )
            ],
          ),
        )
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

// ignore: must_be_immutable
class CountDown extends StatefulWidget {
  int timefortimer;
  CountDown(this.timefortimer);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin{

  int time;
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    String timeDisplay = '${duration.inHours}:${duration.inMinutes%60}:${(duration.inSeconds%60).toString().padLeft(2, '0')}';
    return timeDisplay;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timefortimer),
    );
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(fit: StackFit.loose,
                            children: <Widget>[
                              Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 10,
                                    lightSource: LightSource.topLeft,
                                  ),
                                  child: Center()
                              ),
                              Positioned.fill(
                                child:
                                AnimatedBuilder(
                                  animation: controller,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return CustomPaint(
                                        painter: CustomTimerPainter(
                                          animation: controller,
                                          backgroundColor: Colors.white,
                                          color: Colors.blue,
                                        ));
                                  },
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Count Down Timer",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.grey),
                                    ),
                                    controller.isAnimating?
                                    AnimatedBuilder(
                                        animation: controller,
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Text(
                                            timerString,
                                            style: TextStyle(
                                                fontSize: 60.0,
                                                color: Colors.black87),
                                          );
                                        }):BlinkingTextAnimation(timerString, fontSize: 60,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NeumorphicButton(
                        child: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 24,),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 10,
                          lightSource: LightSource.topLeft,
                        ),
                        onPressed: () {Navigator.pop(context);},
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(backgroundColor: controller.isAnimating ? Colors.red:Colors.white,
                                onPressed: () {
                                  if (controller.isAnimating)
                                    controller.stop();
                                  else {
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(controller.isAnimating ? "Pause" : "Play", ));
                          }),
                    ],
                  ),

                ],
              ),
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);
    final Gradient gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent, Colors.cyanAccent],
        );

    Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(boundingSquare);

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = ( 1.0 - animation.value) * 2 * (3.14);
    canvas.drawArc(Offset.zero & size, (3.14) * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}