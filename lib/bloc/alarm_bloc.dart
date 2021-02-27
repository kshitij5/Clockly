import 'dart:async';
import 'package:clockly/models/alarm_model.dart';
import 'package:clockly/widgets/alarm_helper.dart';
import 'Bloc_Provider.dart';

class AlarmBloc implements BlocBase {
  final _alarmController = StreamController<List<AlarmInfo>>.broadcast();
  StreamSink<List<AlarmInfo>> get _inAlarms => _alarmController.sink; // Input stream. We add our notes to the stream using this variable.
  Stream<List<AlarmInfo>> get outAlarms => _alarmController.stream;

  final _addAlarmController = StreamController<AlarmInfo>.broadcast();///ADD STREAM
  StreamSink<AlarmInfo> get inAddAlarm => _addAlarmController.sink;


  final _updateAlarmController = StreamController<AlarmInfo>.broadcast();///UPDATE STREAM
  StreamSink<AlarmInfo> get inUpdateAlarm => _updateAlarmController.sink;


  final _deleteAlarmController = StreamController<int>.broadcast();///DELETE STREAM
  StreamSink<int> get inDeleteAlarm => _deleteAlarmController.sink;

  AlarmBloc(){
    getAlarm();

    _addAlarmController.stream.listen(addAlarms);
    _updateAlarmController.stream.listen(updateAlarms);
    _deleteAlarmController.stream.listen(deleteAlarms);
  }

  void getAlarm() async {
    List<AlarmInfo> alarms = await AlarmHelper().getAlarms();
    _inAlarms.add(alarms);
  }

  void addAlarms(AlarmInfo alarmInfo) async {
    AlarmHelper().insertAlarm(alarmInfo);
    getAlarm();
  }

  void updateAlarms(AlarmInfo alarmInfo) async {
    AlarmHelper().updateAlarm(alarmInfo);
    getAlarm();
  }

  void deleteAlarms(int id) async {
    await AlarmHelper().delete(id);
    getAlarm();
  }

  @override
  void dispose() {
    _alarmController.close();
    _addAlarmController.close();
    _updateAlarmController.close();
    _deleteAlarmController.close();
  }// Output stream. This one will be used within our pages to display the notes.
}