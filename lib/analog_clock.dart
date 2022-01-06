import 'dart:math';

import 'package:flutter/material.dart';

class AnalogClock extends StatelessWidget {
  final DateTime dateTime;

  const AnalogClock(this.dateTime);

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 5,
              blurRadius: 12,
              offset: Offset(0, 7) // changes position of shadow
            )
          ]
        ),
        child: CustomPaint(
          painter: _BackgroundPainter(context),  
          foregroundPainter: _ForegroundPainter(context, dateTime)
        ) 
      )
    );
  }

}

class _BackgroundPainter extends CustomPainter {
  final BuildContext context;

  const _BackgroundPainter(this.context);

  void _drawLineClock(
    Canvas canvas, 
    Size size, 
    {
      int clockAngel = 0, 
      Color color = Colors.amber, 
      double thickness = 5.0, 
      double padding = 8.0, 
      double lenght = 30
    }
  ){

    double centerX = size.width/2;
    double centerY = size.height/2;

    double xFrom = centerX + (centerX-padding) * sin((clockAngel * 6 * pi) / 180);
    double yFrom = centerY + (centerY-padding) * -cos((clockAngel * 6 * pi) / 180);
    double xTo = centerX + (centerX-padding-lenght) * sin((clockAngel * 6 * pi) / 180);
    double yTo = centerY + (centerY-padding-lenght) * -cos((clockAngel * 6 * pi) / 180);

    Offset from = Offset(xFrom, yFrom);
    Offset to = Offset(xTo, yTo);

    canvas.drawLine(
      from, 
      to, 
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
    );

  }

  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i < 60; i++){
      if(i % 5 == 0){
        _drawLineClock(canvas, size, color: Theme.of(context).primaryColor, clockAngel: i, thickness: size.width*0.015,lenght: size.width*0.06);
      } else {
        _drawLineClock(canvas, size, color: Theme.of(context).accentColor, clockAngel: i, thickness: size.width*0.005, lenght: size.width*0.03);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

class _ForegroundPainter extends CustomPainter {
  final BuildContext context;
  final DateTime dateTime;

  _ForegroundPainter(this.context, this.dateTime);

  void _drawCircleClock(
    Canvas canvas, 
    Size size, 
    {
      double radius = 20.0, 
      Color color = Colors.amber,
    }
  ){

    double centerX = size.width/2;
    double centerY = size.height/2;

    Offset center = Offset(centerX, centerY);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
    );

  }

  void _drawLineMinutes(
    Canvas canvas, 
    Size size, 
    DateTime clock,
    { 
      Color color = Colors.amber, 
      double thickness = 5.0,
      double padding = 50.0,
    }
  ){
    double centerX = size.width/2;
    double centerY = size.height/2;

    double x = centerX + (centerX - padding) * sin(clock.minute * 6 * pi / 180);
    double y = centerY + (centerY - padding) * -cos(clock.minute * 6 * pi / 180);

    Offset center = Offset(centerX, centerY);
    Offset to = Offset(x, y);

    canvas.drawLine(
      center, 
      to, 
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
    );
  }

  void _drawLineHours(
    Canvas canvas, 
    Size size, 
    DateTime clock,
    {
      Color color = Colors.amber, 
      double thickness = 5.0,
      double padding = 50.0,
    }
  ){
    double centerX = size.width/2;
    double centerY = size.height/2;

    double x = centerX + (centerX - padding) * sin((clock.hour * 30 + clock.minute * 0.5) * pi / 180);
    double y = centerY + (centerY - padding) * -cos((clock.hour * 30 + clock.minute * 0.5) * pi / 180);

    Offset center = Offset(centerX, centerY);
    Offset to = Offset(x, y);

    canvas.drawLine(
      center, 
      to, 
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawLineMinutes(canvas, size, dateTime, color: Theme.of(context).accentColor, thickness: size.width*0.025, padding: size.width*0.15);
    _drawLineHours(canvas, size, dateTime, color: Theme.of(context).colorScheme.secondary, thickness: size.width*0.035, padding: size.width*0.2);
    _drawCircleClock(canvas, size, radius: size.width*0.05, color: Theme.of(context).accentColor);
    _drawCircleClock(canvas, size, radius: size.width*0.02, color: Theme.of(context).primaryColor);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}