
class AlarmInfo{
  int id;
  String title;
  DateTime alarmDateTime;
  int isPending;

  AlarmInfo(
      {this.id,
        this.title,
        this.alarmDateTime,
        this.isPending,});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
    id: json["id"],
    title: json["title"],
    alarmDateTime: DateTime.parse(json["alarmDateTime"]),
    isPending: json["isPending"],
  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "alarmDateTime": alarmDateTime.toIso8601String(),
    "isPending": isPending,
  };

}