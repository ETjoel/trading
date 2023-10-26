import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphTest extends StatefulWidget {
  const GraphTest({super.key});

  @override
  State<GraphTest> createState() => _GraphTestState();
}

class _GraphTestState extends State<GraphTest> {
  int selectedSegment = 0;
  final Map<int, Widget> segmentedItems = {
    0: const Text('1D'),
    1: const Text('5D'),
    2: const Text('1M'),
  };
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CupertinoSegmentedControl<int>(
                  children: segmentedItems,
                  groupValue: selectedSegment,
                  onValueChanged: (int newValue) {
                    setState(() {
                      selectedSegment = newValue;
                    });
                  }),
            ),
            SizedBox(
              height: size.height / 3,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: false,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 1000,
                  minY: 0,
                  maxY: 1000,
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          const FlSpot(0, 0),
                          const FlSpot(1, 4),
                          const FlSpot(200, 300),
                          const FlSpot(300, 6),
                          const FlSpot(500, 900),
                          const FlSpot(600, 1),
                          const FlSpot(900, 200),
                        ],
                        isCurved: false,
                        color: Colors.blue,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: false,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        shadow: const BoxShadow(
                            color: Colors.blue,
                            offset: Offset(0, 20),
                            blurRadius: 5,
                            blurStyle: BlurStyle.inner,
                            spreadRadius: 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
