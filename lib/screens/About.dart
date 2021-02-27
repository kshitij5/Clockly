import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutSection extends StatefulWidget {
  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      debugPrint("can launch");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: () => Navigator.pop(context), label: Text("Back"),icon: Icon(Icons.arrow_back_ios,size: 20,),backgroundColor: Colors.white,),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("a clock app by kshitij",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0, color: Colors.black,fontFamily: 'RobotoMono'),textAlign: TextAlign.center,),
              Text("Clockly",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42.0, color: Colors.black,),),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Get in touch with me  at:    ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0, color: Colors.black,fontFamily: 'RobotoMono'),),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.black,),
                      onPressed: () {_launchURL('https://www.facebook.com/kshitijliveat5');}
                  ),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.black,),
                      onPressed: () {_launchURL('https://www.instagram.com/kshi.tij.5/');}
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Or, leave me a sweet mail at:    ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0, color: Colors.black,fontFamily: 'RobotoMono'),),
                  IconButton(
                      icon: FaIcon(FontAwesomeIcons.envelope, color: Colors.black,),
                      onPressed: () {_launchURL("mailto:kshitijliveat5@gmail.com");}
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("""
Check more 
apps from me: """,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0, color: Colors.black,fontFamily: 'RobotoMono'),),
                  IconButton(
                      iconSize: 120,
                      icon: Image.asset('assets/google-play-badge.png',),
                      onPressed: () {_launchURL("#");}
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("""
THANKS FOR
PLAYING,
kshitij""",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0, color: Colors.black,fontFamily: 'RobotoMono'),),
                  Image.asset('assets/boo.gif',height: 160.0,width: 160.0,),
                ],
              ),
            ],
          ),
        )
    );
  }
}


