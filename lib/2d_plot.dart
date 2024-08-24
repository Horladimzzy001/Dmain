import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Plot2D extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  Plot2D({required this.data});

  @override
  _Plot2DState createState() => _Plot2DState();
}

class _Plot2DState extends State<Plot2D> {
  String? selectedXAxis;
  String? selectedYAxis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Plot'),
        centerTitle: true,
      ),
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
                items: _getVariableNames().map((String axis) {
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
                items: _getVariableNames().map((String axis) {
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
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
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
            color: Colors.blue,  // Corrected to use `colors`
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generatePlotSpots() {
    List<FlSpot> spots = [];
    for (var row in widget.data) {
      print('Row: $row');  // Debugging: Print each row of data

      double? xValue = _getValueFromVariable(row, selectedXAxis!);
      double? yValue = _getValueFromVariable(row, selectedYAxis!);

      print('X: $xValue, Y: $yValue');  // Debugging: Print values for the selected axes

      if (xValue != null && yValue != null) {
        spots.add(FlSpot(xValue, yValue));
      }
    }
    print('Generated spots: $spots');  // Debugging: Print the generated spots
    return spots;
  }

  double? _getValueFromVariable(Map<String, dynamic> row, String variable) {
    switch (variable) {
      case "Northern":
        return row["northern"]?.toDouble();
      case "Eastern":
        return row["eastern"]?.toDouble();
      case "TVD":
        return row["tvd"]?.toDouble();
      case "Measured Depth":
        return row["md"]?.toDouble();
      case "Inclination":
        return row["inclination"]?.toDouble();
      case "Azimuth":
        return row["azimuth"]?.toDouble();
      case "Dogleg":
        return row["dogleg"]?.toDouble();
      default:
        return null;
    }
  }

  List<String> _getVariableNames() {
    return ["Northern", "Eastern", "TVD", "Measured Depth", "Inclination", "Azimuth", "Dogleg"];
  }
}
