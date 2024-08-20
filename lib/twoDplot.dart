import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class PlottingPage extends StatefulWidget {
  @override
  _PlottingPageState createState() => _PlottingPageState();
}

class _PlottingPageState extends State<PlottingPage> {
  String? selectedXAxis;
  String? selectedYAxis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showAxisSelectionDialog,
            child: Center(child: Text("Plot 2D Graph")),
          ),
          if (selectedXAxis != null && selectedYAxis != null)
            Expanded(child: _build2DPlot())
        ],
      ),
    );
  }

  void _showAxisSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Axes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: Text("Select X Axis"),
                value: selectedXAxis,
                onChanged: (value) {
                  setState(() {
                    selectedXAxis = value!;
                  });
                },
                items: ["Northern", "Eastern", "TVD"].map((String axis) {
                  return DropdownMenuItem<String>(
                    value: axis,
                    child: Text(axis),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                hint: Text("Select Y Axis"),
                value: selectedYAxis,
                onChanged: (value) {
                  setState(() {
                    selectedYAxis = value!;
                  });
                },
                items: ["Northern", "Eastern", "TVD"].map((String axis) {
                  return DropdownMenuItem<String>(
                    value: axis,
                    child: Text(axis),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Plot"),
            )
          ],
        );
      },
    );
  }

  Widget _build2DPlot() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: _generatePlotSpots(),
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generatePlotSpots() {
    // Assuming you have a way to fetch data based on the selected axes.
    // This function should return a list of FlSpots for the graph.
    // For example:
    return [
      FlSpot(0, 0),
      FlSpot(1, 1),
      FlSpot(2, 4),
      FlSpot(3, 9),
    ];
  }

  Future<void> _exportPlot() async {
    final boundary = context.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    // Save or share the image using the buffer
  }
}
