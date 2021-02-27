import 'package:clockly/bloc/alarm_bloc.dart';
import 'package:clockly/models/alarm_model.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  DateTime _alarmTime;
  int lastIndex;
  bool status = true;

  TimeOfDay _time = TimeOfDay.now();
  AlarmBloc _alarmBloc = AlarmBloc();

  @override
  void initState() {
    _alarmTime = DateTime.now();
    super.initState();
  }

  void onTimeChanged(newTime) {
    setState(() {
      _time = newTime;
      _alarmTime = DateTime(_alarmTime.year, _alarmTime.month, _alarmTime.day, _time.hour, _time.minute);
    });
    addAlarm();
  }

  void addAlarm(){
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now())) scheduleAlarmDateTime = _alarmTime;
    else scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(alarmDateTime: scheduleAlarmDateTime, title: 'alarm', isPending: 1,);
    _alarmBloc.inAddAlarm.add(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime);
  }
  void updateAlarm(AlarmInfo alarmInfo){
    DateTime scheduleAlarmDateTime;
    if (alarmInfo.alarmDateTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = alarmInfo.alarmDateTime;
    else
      scheduleAlarmDateTime = alarmInfo.alarmDateTime.add(Duration(days: 1));

    _alarmBloc.inUpdateAlarm.add(alarmInfo);
    alarmInfo.isPending==1?
    scheduleAlarm(scheduleAlarmDateTime):cancelScheduledAlarm(alarmInfo.id, true);
  }
  void deleteAlarm(AlarmInfo alarm){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Are you sure you want to delete the Alarm?",
        style: TextStyle(color: Colors.white),),
      duration: Duration(seconds: 4),backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Delete',
        onPressed: () {
          _alarmBloc.inDeleteAlarm.add(alarm.id);
          cancelScheduledAlarm(alarm.id, false);
        },
        disabledTextColor: Colors.yellow,
        textColor: Colors.white,
      ),
    ));
  }

  Widget slideLeftBackground() {
    return Container(
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)),color: Colors.red,),
    );
  }
  Widget slideRightBackground() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)),color: Colors.green,),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NeumorphicButton(
        child: Icon(Icons.add, color: Colors.grey, size: 30,),
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 4
        ),
        onPressed: () {
          Navigator.of(context).push(
            showPicker(
              context: context,
              value: TimeOfDay.now(),
              onChange: onTimeChanged,
              blurredBackground: true,
            ),
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30,top: 20),
        child: StreamBuilder<List<AlarmInfo>>(
          stream: _alarmBloc.outAlarms,
          builder: (context, snapshot) {

            if(!snapshot.hasData)
              return Center(
                child: Text(
                  'Loading..',
                  style: TextStyle(color: Colors.white),
                ),
              );
            lastIndex = snapshot.data.length;
            print("last index : $lastIndex");

            return snapshot.data.length>0?
            ListView(
              children: snapshot.data.map<Widget>((alarm) {
                var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  dragStartBehavior: DragStartBehavior.start,
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  child: Neumorphic(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.label, color: _color(context), size: 24,),
                                  SizedBox(width: 8),
                                  Text(alarm.title, style: TextStyle(color: _color(context), fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: NeumorphicSwitch(
                                  style: NeumorphicSwitchStyle(activeTrackColor: Colors.blue),
                                  isEnabled: true,
                                  height: 30,
                                  onChanged: (bool value) {
                                    setState(() {
                                      alarm.isPending = alarm.isPending==1?0:1;
                                      updateAlarm(alarm);
                                    });},
                                  value: alarm.isPending==1?true:false,),
                              ),
                            ],
                          ),
                          Text('Mon-Fri', style: TextStyle(color: _color(context), fontFamily: 'avenir'),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(alarmTime, style: TextStyle(color: _color(context), fontFamily: 'avenir', fontSize: 24, fontWeight: FontWeight.w700),),
                              IconButton(
                                icon: Icon(Icons.delete, size: 25,),
                                color: _color(context),
                                onPressed: () => deleteAlarm(alarm),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                          depth: 4,
                          lightSource: LightSource.topLeft,
                          color: Colors.white38
                      )),
                  // ignore: missing_return
                  confirmDismiss: (direction) {
                    if(direction==DismissDirection.startToEnd){
                      print("Dialog box for edit appears");
                    }
                    else deleteAlarm(alarm);
                  },
                );
              }).toList(),
            )
                :Center(child: Text("Looks so desolate here"),);
          },
        ),
      ),
    );
  }
  Future<void> cancelScheduledAlarm(id, isCancelled) async {// cancel the notification with id value of zero
    await flutterLocalNotificationsPlugin.cancel(id);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(isCancelled?"You Alarm has been Cancelled!":"You Alarm has been Deleted!",
        style: TextStyle(color: Colors.white),),
      duration: Duration(seconds: 3),backgroundColor: Colors.redAccent,
    ));
  }
  void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'icon',
      priority: Priority.High,
      importance: Importance.Max,
      ongoing: true,playSound: true,
      styleInformation: BigTextStyleInformation(''),
      sound: RawResourceAndroidNotificationSound('alarmringtone'),
      largeIcon: DrawableResourceAndroidBitmap('icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'alarmringtone.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      lastIndex,
      'Alarm',
      'Seems, it a good time to notify you that you forgot something!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Custom_Sound',);

    // final DateFormat formatter = DateFormat('MMM d h:m');
    // final String formatted = formatter.format(scheduledNotificationDateTime);
    final date = DateTime.now();
    final difDay = scheduledNotificationDateTime.difference(date).inDays;
    final difHour = scheduledNotificationDateTime.difference(date).inHours;
    final difMin = (scheduledNotificationDateTime.difference(date).inMinutes-difHour*60);
    String formatted = "$difDay days $difHour hour $difMin min";
    print(scheduledNotificationDateTime);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You Alarm has been set after $formatted",style: TextStyle(color: Colors.white),),
      duration: Duration(seconds: 3),backgroundColor: Colors.green,
    ));
  }
  Color _color(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
