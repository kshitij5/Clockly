import 'package:clockly/screens/About.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AlarmView.dart';
import 'ClockView.dart';
import 'StopwatchView.dart';
import 'TimerView.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedView = 0;
  void _handleIndexChanged(int i) {
    setState(() {
      _selectedView = i;
    });
  }

  Color _color(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
  _selectColor(int i){return _selectedView==i?Colors.blueAccent:NeumorphicTheme.isUsingDark(context)?Color(0xFF202020):Colors.white;}
  _selectDept(int i){return _selectedView==i?-20.0:5.0;}
  _returnShape(){if(NeumorphicTheme.isUsingDark(context)) return NeumorphicShape.flat; else return NeumorphicShape.concave;}

  @override
  Widget build(BuildContext context) {
    print("refresh");
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: NeumorphicAppBar(
          title: Text("Clockly", style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: _color(context),)),
          actions: [
            ///DARK MODE
            // Padding(
            //   padding: const EdgeInsets.all(3.0),
            //   child: NeumorphicButton(
            //     onPressed: () {setState(() {
            //     });
            //     NeumorphicTheme.of(context).themeMode =
            //     NeumorphicTheme.isUsingDark(context) ? ThemeMode.light : ThemeMode.dark;
            //     },
            //     style: NeumorphicStyle(
            //       shape: NeumorphicShape.flat,
            //       boxShape: NeumorphicBoxShape.circle(),
            //     ),
            //     child: Icon(NeumorphicTheme.isUsingDark(context)?EvaIcons.moonOutline:EvaIcons.sunOutline, color: _color(context),),),
            // ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: NeumorphicButton(
                onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => AboutSection())),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                child: Center(child: FaIcon(Icons.android,size: 20, color: _color(context),)),),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              NeumorphicButton(
                onPressed: () => _handleIndexChanged(0),
                style: NeumorphicStyle(
                    shape: _returnShape(),
                    color: _selectColor(0),
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: _selectDept(0),
                    intensity: 2
                ),
                child: Container(child: FlareActor("assets/clockview.flr", alignment:Alignment.center, fit:BoxFit.cover, animation:_selectedView==0?"go":"idle",color: _color(context),),width: 28,height: 23,),),//Icon(EvaIcons.clockOutline, color: _color(context),),),
              NeumorphicButton(
                onPressed: () => _handleIndexChanged(1),
                style: NeumorphicStyle(
                    shape: _returnShape(),
                    color: _selectColor(1),
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: _selectDept(1),intensity: 2
                ),
                child: Container(child: FlareActor("assets/alarmview.flr", alignment:Alignment.center, fit:BoxFit.cover, animation:_selectedView==1?"go":"idle",color: _color(context),),width: 28,height: 23,),),//Icon(Icons.alarm, color: _color(context),),),
              NeumorphicButton(
                onPressed: () => _handleIndexChanged(2),
                style: NeumorphicStyle(
                    shape: _returnShape(),
                    color: _selectColor(2),
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: _selectDept(2),intensity: 2
                ),
                child: Container(child: FlareActor("assets/timerview.flr", alignment:Alignment.center, fit:BoxFit.cover, animation:_selectedView==2?"go":"idle",color: _color(context),),width: 28,height: 23,),),//Icon(Icons.timer, color: _color(context),),),
              NeumorphicButton(
                onPressed: () => _handleIndexChanged(3),
                style: NeumorphicStyle(
                    shape: _returnShape(),
                    color: _selectColor(3),
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: _selectDept(3),
                    intensity: 2
                ),
                child: Container(child: FlareActor("assets/stopwatchview.flr", alignment:Alignment.center, fit:BoxFit.cover, animation: _selectedView==3?"go":"idle",color: _color(context),),width: 28,height: 23,),),//Icon(Icons.watch, color: _color(context),),),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedView,
          children: [
          ClockView(),
          Alarm(),
          StopWatch(),
          TimerView()
        ],)
        //menu(_selectedView)
    );
  }
}
