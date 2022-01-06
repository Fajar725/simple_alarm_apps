import 'dart:convert';

class History {
  final Duration alarmRingHistory;

  History(this.alarmRingHistory);

  factory History.fromJson(Map<String, dynamic> json){
    return History(
      json['alarmRingHistory'] as Duration,
    );
  }

  factory History.fromJsonString(String json) {
    Map<String, dynamic> result = jsonDecode(json);

    return History.fromJson(result);
    
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      "alarmRingHistory": this.alarmRingHistory
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }


}