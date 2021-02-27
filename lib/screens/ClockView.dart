import 'dart:async';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  Timer _timer;
  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
  }
  void setTime(Timer timer) {
    setState(() {});
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('HH:mm:ss').format(now);
    String date = DateFormat.yMMMEd('en_US').format(now);
    var timezone = now.timeZoneOffset.toString().split('.').first;
    if(!timezone.startsWith('-'))timezone="+$timezone";
    return Center(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Column(
          children: [
            Container(
                width: 500,
                height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(alignment: Alignment.center,
                children: [
                  Container(
                    child: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicTheme.isUsingDark(context)?NeumorphicShape.flat:NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.circle(),depth: 10
                        ),
                      child: Center()
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                      ),
                      child: Center(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: CustomPaint(
                        painter: ClockPainter(),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 25),
              child: NeumorphicText("$time",
                style: NeumorphicStyle(
                  depth: 2,  //customize depth here
                  color: _color(context),//customize color here
                ),
                textStyle: NeumorphicTextStyle(
                    fontSize: 95, //cu
                    fontWeight: FontWeight.w700// stomize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
              child: Text("$date", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, fontFamily: 'RobotoMono', color: Colors.black87,),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.globeAsia, color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("${now.timeZoneName} $timezone", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'RobotoMono', color: Colors.grey),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Color _color(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();//parse("2012-02-27 10:10:30");
  //60 sec - 360,
  // 1 sec - 6degree
  //12 hours  - 360,
  //1 hour - 30degrees,
  // 1 min - 0.5degrees
  @override
  void paint(Canvas canvas, Size size){
  var centerX = size.width / 2;
  var centerY = size.height / 2;
  var center = Offset(centerX, centerY);
  var radius = min(centerX, centerY);

    var secHandBrush = Paint()
      ..color =  Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    var minHandBrush = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    var hourHandBrush = Paint()
    ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    var dashBrush = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    var hourHandX = centerX + radius * 0.4 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY + radius * 0.4 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + radius * 0.8 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + radius * 0.8 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

  var outerRadius = radius;
  var innerRadius = radius * 0.85;
  for (var i = 0; i < 360; i += 90) {
    var x1 = centerX + outerRadius * cos(i * pi / 180);
    var y1 = centerY + outerRadius * sin(i * pi / 180);

    var x2 = centerX + innerRadius * cos(i * pi / 180);
    var y2 = centerY + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
  }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {return true;}
}
