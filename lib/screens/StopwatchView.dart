import 'dart:async';
import 'dart:math';
import 'package:clockly/widgets/BlinkingText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> with AutomaticKeepAliveClientMixin<StopWatch>, SingleTickerProviderStateMixin{//with AutomaticKeepAliveClientMixin<OnePage>with SingleTickerProviderStateMixin
  var _height,_width;
  var buttonState = "Start";
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  String millisecondsStr = '00';

  var watch = Stopwatch();
  final duration =  const Duration(milliseconds: 1);
  void startTimer(){
    Timer.periodic(duration, (Timer timer){
    //if(watch.isRunning)startTimer();
    if (!mounted) return;
    setState(() {
      hoursStr = watch.elapsed.inHours.toString().padLeft(2, '0');
      minutesStr = (watch.elapsed.inMinutes%60).toString().padLeft(2, '0');
      secondsStr = (watch.elapsed.inSeconds%60).toString().padLeft(2, '0');
      millisecondsStr = (watch.elapsed.inMilliseconds % 1000).toString().padLeft(2, '0');
    });
  });}

  void startWatch(){setState(() {if (!mounted) return;buttonState = "Pause";});watch.start();startTimer();}
  void pauseWatch(){watch.stop();setState(() {buttonState = "Resume";});}
  void resetWatch(){
    if (!mounted) return;
    setState(() {
      buttonState = "Start";
      hoursStr = '00';
      minutesStr = '00';
      secondsStr = '00';
      millisecondsStr = '00';
    });
    watch.stop();
    watch.reset();
  }

  @override
  void dispose() {
    watch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: double.infinity,
                height: _height*0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      //width: double.infinity,
                      child: Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 6,
                            lightSource: LightSource.topLeft,
                          ),
                          child: Center()
                      ),
                    ),
                    Container(
                      width: _width,
                      height: _height,
                      child: CustomPaint(
                      painter: Outline(),
                    ),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 35,),
                        watch.isRunning?Text(
                          "$hoursStr:$minutesStr:$secondsStr",
                          style: TextStyle(
                            fontSize: 45.0,
                          ),
                        ):BlinkingTextAnimation("$hoursStr:$minutesStr:$secondsStr",fontSize: 45,),
                        Text(
                          "$millisecondsStr",
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            SizedBox(height: 65,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                //padding: const EdgeInsets.symmetric(horizontal: 25),
                width: _width*.4,
                height: 45,
                child: NeumorphicButton(
                    onPressed: () {
                      watch.isRunning?pauseWatch():startWatch();
                    },
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30))
                    ),
                    child: Center(child: Text(buttonState, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18)))
                ),
              ),
              Container(
                //padding: const EdgeInsets.all(3.0),
                width: _width*.4,
                height: 45,
                child: NeumorphicButton(
                    onPressed: () => resetWatch(),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30))
                    ),
                    child: Center(child: Text("Reset", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.redAccent, fontSize: 18),))
                ),
              ),
            ],)
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Outline extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size){

    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);

    var dashBrush = Paint()
      ..color = Colors.grey.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var outerRadius = radius;
    var innerRadius = radius * 0.85;
    for (var i = 0; i < 360; i += 3) {
      var x1 = centerX + outerRadius * cos(i * pi / 180) * 0.95;
      var y1 = centerY + outerRadius * sin(i * pi / 180) * 0.95;

      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
