import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_alarm_apps/constant/custom_theme.dart';
import 'package:simple_alarm_apps/data/notification_config.dart';
import 'package:simple_alarm_apps/history_view.dart';
import 'package:simple_alarm_apps/model/alarm.dart';
import 'package:simple_alarm_apps/model/theme.dart';
import 'package:simple_alarm_apps/analog_clock.dart';
import 'package:simple_alarm_apps/utils/date_converter.dart';
import 'package:simple_alarm_apps/data/presistence_config.dart';
import 'package:simple_alarm_apps/utils/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    NotificationConfig.initialize(context);

    return ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, theme, child) {
          return MaterialApp(
            title: 'Simple Alarm Apps',
            debugShowCheckedModeBanner: false,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
            home: MainPage(),
          );
        }
      ),
    );
  }
}

class MainPage extends StatefulWidget {

  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  DateTime _dateTimeNow = DateTime.now();
  DateTime _dateTimeAlarm;
  String _dateTimeAlarmAmPm;
  String _hoursLeft;

  double _alignmentX = -0.034;

  bool _activeAlarm;

  double _gestureWidth;

  int get _hours12 => int.parse(hours24To12(_dateTimeAlarm).substring(11, 13))-1;
  int get _hours12AmPn => hours24To12(_dateTimeAlarm).substring(17, 19) == "AM" ? 0 : 1;

  void getPreferences() async {
    String _presistenceString/*await PresistenceConfig.getInstance().getPreferences(PreferencesEnum.ALARM)*/;

    if(_presistenceString != null){
      Alarm _presistenceAlarm = Alarm.fromJsonString(_presistenceString);
        
      _dateTimeAlarm = _presistenceAlarm.alarm;
      _activeAlarm = _presistenceAlarm.isActivel;
    } else {
      _dateTimeAlarm = DateTime(_dateTimeNow.year, _dateTimeNow.month, _dateTimeNow.day, 5, 30);
      _activeAlarm = false;
    }

    if(_dateTimeAlarmAmPm == null) {
       _dateTimeAlarmAmPm = hours24To12(_dateTimeAlarm);
    }
  }

  // void activateAlarm(){
  //   if(_activeAlarm){
  //     NotificationConfig.cancel();
  //     NotificationConfig.showSceduleNotification(_dateTimeAlarm, payload: dateToJsonString(_dateTimeAlarm));
  //   }
  // }

  void listenNotification() => NotificationConfig.onNotification.listen(onClickedNotification);

  void onClickedNotification(String payload) => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (context) => HistoryView(payload)),
  );

  int get _getCompare => _dateTimeAlarm.compareTo(DateTime.now());
  Duration get _getDifference => _dateTimeAlarm.difference(DateTime.now());

  @override
  void initState() {
    super.initState();

    getPreferences();

    // activateAlarm();

    listenNotification();

    Timer.periodic(Duration(seconds: 1), (timer) {
      int _compare = _getCompare;
      Duration _diff = _getDifference;

      if(_activeAlarm){
        _hoursLeft = durationToStringClock(_diff);

        if(_compare < 0){
          _alignmentX = -0.034;
          _activeAlarm = false;
        }

        setState(() {});
      }
    });

  }

  @override
  Widget build(BuildContext context){

    _gestureWidth = (MediaQuery.of(context).size.width-48)/2;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  padding: EdgeInsets.zero,
                  minWidth: 50,
                  height: 50,
                  onPressed: (){
                    Provider.of<ThemeModel>(context, listen: false).changeTheme();
                  }, 
                  child: Icon(
                    Icons.brightness_6,
                    color: Theme.of(context).primaryColor,
                  )
                ),
                Text(
                  "My Alarm",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch(
                  value: _activeAlarm, 
                  inactiveTrackColor: Theme.of(context).accentColor,
                  activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool){
                    _activeAlarm = bool;
                    int _diff = _getCompare;

                    if(_diff < 0){
                      _dateTimeAlarm = _dateTimeAlarm.add(new Duration(days: 1));
                    }

                    _hoursLeft = durationToStringClock(_getDifference);

                    if(bool){
                      _alignmentX = 0.0;
                      NotificationConfig.showSceduleNotification(_dateTimeAlarm);
                      PresistenceConfig.getInstance().setPreferences(PreferencesEnum.ALARM, Alarm(alarm: _dateTimeAlarm, isActivel: _activeAlarm).toJsonString());
                    } else {
                      _alignmentX = -0.034;
                      NotificationConfig.cancel();
                    }

                    setState(() {});
                  }
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 7) // changes position of shadow
                      )
                    ]
                  ),
                  child: Center(
                    child: Text(
                      addZeroOnfront(_dateTimeAlarm.hour.toString()),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  )
                ),
                SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 7) // changes position of shadow
                      )
                    ]
                  ), 
                  child: Center(
                    child: Text(
                      addZeroOnfront(_dateTimeAlarm.minute.toString()),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  )
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              _activeAlarm ? "Next Alarm On $_hoursLeft" : "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 20),
            SizedBox(width: 250, child: AnalogClock(_dateTimeAlarm)),
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details){
                  print("START : ${details.localPosition.dx}");
                  _alignmentX = (details.localPosition.dx-_gestureWidth)/_gestureWidth;
                  setState(() {});
                },
                onHorizontalDragEnd: (details) {
                  double _nearHour = (_alignmentX - (-0.411)).abs();
                  double _nearMinutes = (_alignmentX - (-0.034)).abs();
                  double _nearAmPm = (_alignmentX - 0.376).abs();

                  print("END : $_nearHour : $_nearMinutes : $_nearAmPm");

                  if(_nearHour < _nearMinutes && _nearHour < _nearAmPm) {
                    _alignmentX = -0.411;
                    setState(() {});
                  } else if (_nearMinutes < _nearHour && _nearMinutes < _nearAmPm) {
                    _alignmentX = -0.034;
                    setState(() {});
                  }
                  else if (_nearAmPm < _nearHour && _nearAmPm < _nearMinutes) {
                    _alignmentX = 0.376;
                    setState(() {});
                  }
                },
                child: Stack(
                  children: [
                    !_activeAlarm ? Align(
                      //-0.411 ,-0.034, 0.376
                      alignment: Alignment(_alignmentX,0.0),
                      child: Container(
                        width: 50,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Theme.of(context).primaryColor,
                          //     Theme.of(context).accentColor
                          //   ]
                          // )
                        )
                      )
                    ) : Container(),
                    Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _alignmentX != -0.411 ? Text(
                            addZeroOnfront((_hours12+1).toString()),
                            style: Theme.of(context).textTheme.headline5,
                          ) : SizedBox(
                            width: 40,
                            height: 100,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: _hours12),
                              itemExtent: 50, 
                              onSelectedItemChanged: (value) {
                                _dateTimeAlarmAmPm = _dateTimeAlarmAmPm.replaceRange(11, 13, addZeroOnfront((value+1).toString()));
                                _dateTimeAlarm = hours12To24(_dateTimeAlarmAmPm);
                                // PresistenceConfig.getInstance().setPreferences(PreferencesEnum.ALARM, Alarm(alarm: _dateTimeAlarm, isActivel: _activeAlarm).toJsonString());
                                setState(() {});
                              },
                              children: List.generate(
                                12, (index) => Center(
                                  child: Text(
                                    addZeroOnfront((index+1).toString()),
                                    style: GoogleFonts.lato(fontSize: 28, color: Theme.of(context).scaffoldBackgroundColor)
                                  ),
                                )
                              )
                            ),
                          ),
                          SizedBox(width: 20),
                          _alignmentX != -0.034 ? Text(
                            addZeroOnfront(_dateTimeAlarm.minute.toString()),
                            style: Theme.of(context).textTheme.headline5,
                          ) : SizedBox(
                            width: 40,
                            height: 100,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: _dateTimeAlarm.minute),
                              itemExtent: 50, 
                              onSelectedItemChanged: (value){
                                _dateTimeAlarmAmPm = _dateTimeAlarmAmPm.replaceRange(14, 16, addZeroOnfront(value.toString()));
                                _dateTimeAlarm = hours12To24(_dateTimeAlarmAmPm);
                                // PresistenceConfig.getInstance().setPreferences(PreferencesEnum.ALARM, Alarm(alarm: _dateTimeAlarm, isActivel: _activeAlarm).toJsonString());
                                setState(() {});
                              },
                              children: List.generate(
                                60, (index) => Center(
                                  child: Text(
                                    addZeroOnfront(index.toString()),
                                    style: GoogleFonts.lato(fontSize: 28, color: Theme.of(context).scaffoldBackgroundColor)
                                  ),
                                )
                              )
                            ),
                          ),
                          SizedBox(width: 20),
                          _alignmentX != 0.376 ? Text(
                            _hours12AmPn == 0 ? "AM" : "PM",
                            style: Theme.of(context).textTheme.headline5,
                          ) : SizedBox(
                            width: 50,
                            height: 100,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: _hours12AmPn),
                              itemExtent: 60, 
                              onSelectedItemChanged: (value){
                                _dateTimeAlarmAmPm = _dateTimeAlarmAmPm.replaceRange(17, 19, value == 0 ? "AM" : "PM");
                                _dateTimeAlarm = hours12To24(_dateTimeAlarmAmPm);
                                // PresistenceConfig.getInstance().setPreferences(PreferencesEnum.ALARM, Alarm(alarm: _dateTimeAlarm, isActivel: _activeAlarm).toJsonString());
                                setState(() {});
                              },
                              children: List.generate(
                                2, (index) => Center(
                                  child: Text(
                                    index == 0 ? "AM" : "PM",
                                    style: GoogleFonts.lato(fontSize: 26, color: Theme.of(context).scaffoldBackgroundColor)
                                  ),
                                )
                              )
                            ),
                          )
                        ]
                      ),
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }

}
