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
  List<String> variables = ["Northern", "Eastern", "TVD", "Measured Depth", "Inclination", "Azimuth", "Dogleg"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Plot'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // X-Axis Selector
            Text('Select X-Axis:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedXAxis,
              hint: Text('Choose X-Axis'),
              isExpanded: true,
              items: variables.map((String variable) {
                return DropdownMenuItem<String>(
                  value: variable,
                  child: Text(variable),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedXAxis = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            // Y-Axis Selector
            Text('Select Y-Axis:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedYAxis,
              hint: Text('Choose Y-Axis'),
              isExpanded: true,
              items: variables.map((String variable) {
                return DropdownMenuItem<String>(
                  value: variable,
                  child: Text(variable),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedYAxis = newValue;
                });
              },
            ),
            SizedBox(height: 32),
            // Plot Button
            Center(
              child: ElevatedButton(
                onPressed: (selectedXAxis != null && selectedYAxis != null) ? _plotGraph : null,
                child: Text('Plot Graph'),
              ),
            ),
            SizedBox(height: 32),
            // Display Graph
            if (selectedXAxis != null && selectedYAxis != null)
              Expanded(
                child: _buildGraph(),
              ),
          ],
        ),
      ),
    );
  }

  void _plotGraph() {
    setState(() {
      // Trigger a rebuild to display the graph
    });
  }

  Widget _buildGraph() {
    List<FlSpot> spots = _generateSpots();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: Colors.blue, // Corrected to 'color'
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];

    for (var row in widget.data) {
      double? xValue = _getValueFromVariable(row, selectedXAxis!);
      double? yValue = _getValueFromVariable(row, selectedYAxis!);

      if (xValue != null && yValue != null) {
        spots.add(FlSpot(xValue, yValue));
      }
    }

    return spots;
  }

  double? _getValueFromVariable(Map<String, dynamic> row, String variable) {
    switch (variable) {
      case "Northern":
        return (row["northern"] != null) ? row["northern"].toDouble() : null;
      case "Eastern":
        return (row["eastern"] != null) ? row["eastern"].toDouble() : null;
      case "TVD":
        return (row["tvd"] != null) ? row["tvd"].toDouble() : null;
      case "Measured Depth":
        return (row["md"] != null) ? row["md"].toDouble() : null;
      case "Inclination":
        return (row["inclination"] != null) ? row["inclination"].toDouble() : null;
      case "Azimuth":
        return (row["azimuth"] != null) ? row["azimuth"].toDouble() : null;
      case "Dogleg":
        return (row["dogleg"] != null) ? row["dogleg"].toDouble() : null;
      default:
        return null;
    }
  }
}
