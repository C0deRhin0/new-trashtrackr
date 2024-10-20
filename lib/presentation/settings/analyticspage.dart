import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyticsPage extends StatelessWidget {

  // two elements in the pie chart
  final dataMap = <String, double>{
    "Biodegradable": 5,
    "Non-biodegradable": 5,
  };

  // color of two elements in the pie chart
  final colorList = <Color>[
    Colors.greenAccent,
    Colors.blueAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics and Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'As of this day, we pick up XX gallons of trash in Naga City in just Residential Areas alone.',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  // Pie Chart
                  PieChart( 
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey[300]!,
                    colorList: colorList,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'XX% of them is Biodegradable, XX% is Non-Biodegradable.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Thank you for cooperation for a better environment.',
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
