import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'HomeController.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openStartPage();
  }

  openStartPage() async {
    await Future.delayed(
      Duration(seconds: 5),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 0.6,
          alignment: AlignmentDirectional.center,
          child: Container(child: FlareActor("assets/Clockly-app-splash.flr", alignment:Alignment.center, fit:BoxFit.fill, animation:"go"),height: 300,width: 300,),
        ),
      ),
    );
  }
}
