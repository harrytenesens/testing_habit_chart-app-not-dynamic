import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_habit_chart/categories.dart';
import 'package:testing_habit_chart/methods.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Methods>(
      builder: (context, method, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250,
            width: 300,
            padding: const EdgeInsets.all(20),
            child: RadarChart(
              RadarChartData(
                radarTouchData: RadarTouchData(
                  touchCallback: (FlTouchEvent event, touchResponse) {},
                  enabled: true,
                ),
                dataSets: [
                  // First dataset (e.g., "Product A")
                  RadarDataSet(
                    dataEntries: Provider.of<Methods>(context, listen: false)
                        .getRadarEntries(),
                    fillColor: const Color.fromARGB(82, 33, 149, 243),
                    borderColor: Colors.blue,
                    entryRadius: 5,
                    borderWidth: 2,
                  ),
                  // Second dataset (e.g., "Product B")
                ],
                radarBackgroundColor: const Color.fromARGB(40, 94, 151, 182),

                gridBorderData: BorderSide(
                    color: const Color.fromARGB(102, 76, 175, 79), width: 1),
                ticksTextStyle: const TextStyle(
                  color: Colors.transparent,
                ),

                tickBorderData: const BorderSide(color: Colors.black12),
                radarBorderData: const BorderSide(color: Colors.blue, width: 2),
                tickCount: 5, // Number of concentric polygons (grid lines)

                titlePositionPercentageOffset: 0.2,
                //title
                getTitle: (index, angle) {
                  final categories = [
                    HCategory.productive,
                    HCategory.int,
                    HCategory.strength,
                    HCategory.adaptation,
                    HCategory.effiecient,
                  ];
                  return RadarChartTitle(
                    text: categories[index].name,
                  );
                },

                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
