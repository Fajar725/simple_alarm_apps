import 'dart:convert';

import 'package:simple_alarm_apps/utils/date_converter.dart';

class Alarm {
  final DateTime alarm;
  final bool isActivel;

  Alarm({this.alarm, this.isActivel});

  factory Alarm.fromJson(Map<String, dynamic> json){
    return Alarm(
      alarm: jsonToDateTime(json['alarm'] as String),
      isActivel: json['isActivel'] as bool
    );
  }

  factory Alarm.fromJsonString(String json) {
    Map<String, dynamic> result = jsonDecode(json);

    return Alarm.fromJson(result);
    
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "alarm": dateToJsonString(this.alarm),
      "isActivel": this.isActivel
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

}