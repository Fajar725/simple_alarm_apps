import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget{
  final String payload;

  const HistoryView(this.payload);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
                "My Statistic",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
          Text(
            "Next Alarm On 6 minutes 30 seconds",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          BarChart(),
        ],
      )
    );
  }

}

class BarChart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(),
          SizedBox(width: 20),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 40, color: Colors.red),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 60, color: Colors.blue),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 48, color: Colors.yellow),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 79, color: Colors.green),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 89, color: Colors.cyan),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 40, color: Colors.red),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 60, color: Colors.blue),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 48, color: Colors.yellow),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 79, color: Colors.green),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 89, color: Colors.cyan),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 40, color: Colors.red),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 60, color: Colors.blue),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 48, color: Colors.yellow),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 79, color: Colors.green),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 89, color: Colors.cyan),
          Container(margin: EdgeInsets.only(right: 20), width: 20, height: 100, color: Colors.amber)
        ]
      )
    );
  }

}

