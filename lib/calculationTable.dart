import 'package:flutter/material.dart';
import 'dart:math';

import 'package:phidrillsim_app/twoDplot.dart';

class CalculationTable extends StatelessWidget {
  final Map<String, String>? surfaceLocation;
  final List<Map<String, String>>? targets;
  final bool kopEnabled;
  final double kopValue;

  CalculationTable({
    this.surfaceLocation,  // Optional now
    this.targets,          // Optional now
    this.kopEnabled = false,
    this.kopValue = 345,   // Default KOP value
  });

  double calculateKOP(double x, double y, double tvd, [double buildRate = 2.0]) {
    double hd = sqrt(x * x + y * y);
    double md = sqrt(tvd * tvd + hd * hd);
    double inclinationAngle = atan(hd / tvd) * (180 / pi);
    double mdInclined = (inclinationAngle / buildRate) * 100;
    return md - mdInclined;
  }

  List<Map<String, double>> calculateMIAforLocations(List<Map<String, double>> locations) {
    List<Map<String, double>> results = [];

    for (int i = 0; i < locations.length; i++) {
      Map<String, double> current = locations[i];

      if (i == 0) {
        results.add({
          "measuredDepth": sqrt(current["north"]! * current["north"]! + current["east"]! * current["east"]! + current["tvd"]! * current["tvd"]!),
          "inclination": 0,
          "azimuth": 0,
        });
      } else {
        Map<String, double> previous = locations[i - 1];

        double deltaN = current["north"]! - previous["north"]!;
        double deltaE = current["east"]! - previous["east"]!;
        double deltaTVD = current["tvd"]! - previous["tvd"]!;

        double measuredDepth = sqrt(deltaN * deltaN + deltaE * deltaE + deltaTVD * deltaTVD);

        double horizontalDisplacement = sqrt(deltaN * deltaN + deltaE * deltaE);
        double inclination = atan2(horizontalDisplacement, deltaTVD) * (180 / pi);

        double azimuth = atan2(deltaE, deltaN) * (180 / pi);
        if (azimuth < 0) {
          azimuth += 360;
        }

        if (i == 1) {
          azimuth = applyEtajeMapping(azimuth);
        }

        results.add({
          "measuredDepth": measuredDepth,
          "inclination": inclination,
          "azimuth": azimuth,
        });
      }
    }

    return results;
  }

  double applyEtajeMapping(double azimuth) {
    if (azimuth >= 0 && azimuth <= 120) {
      return 1.5 * azimuth;
    } else if (azimuth >= 240 && azimuth <= 360) {
      return 1.5 * azimuth - 180;
    } else {
      return azimuth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double kop = calculateKOP(
      (double.tryParse(surfaceLocation?['east'] ?? '0') ?? 0) - (double.tryParse(targets?[0]['east'] ?? '0') ?? 0),
      (double.tryParse(surfaceLocation?['north'] ?? '0') ?? 0) - (double.tryParse(targets?[0]['north'] ?? '0') ?? 0),
      double.tryParse(targets?[0]['tvd'] ?? '0') ?? 0,
    );

    final List<Map<String, double>> combinedLocations = [
      {
        "north": double.tryParse(surfaceLocation?['north'] ?? '0') ?? 0,
        "east": double.tryParse(surfaceLocation?['east'] ?? '0') ?? 0,
        "tvd": double.tryParse(surfaceLocation?['tvd'] ?? '0') ?? 0,
      },
      ...?targets?.map((target) => {
        "north": double.tryParse(target['north'] ?? '0') ?? 0,
        "east": double.tryParse(target['east'] ?? '0') ?? 0,
        "tvd": double.tryParse(target['tvd'] ?? '0') ?? 0,
      }).toList(),
    ];

    final List<Map<String, double>> miaResults = calculateMIAforLocations(combinedLocations);

    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis Breakdown"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader("Surface and Target Locations"),
            _buildLocationTable(surfaceLocation ?? {}, targets ?? []),
            SizedBox(height: 16),
            _buildKOPSection(kop),
            SizedBox(height: 16),
            _buildMIASection(miaResults),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _exportData(miaResults, context);
              },
              child: Text("Export MIA"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: Text("2D Plot")),
                    body: PlottingPage(),
                  )),
                );
              },
              child: Text("2D Plot"),
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: Text("2D Plot Placeholder")),
                    body: Center(child: Text("2D Plot Page Placeholder")),
                  )),
                );
              },
              child: Text("3D Plot"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLocationTable(Map<String, String> surfaceLocation, List<Map<String, String>> targets) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(children: [
          _buildTableHeader("Location"),
          _buildTableHeader("N (ft)"),
          _buildTableHeader("E (ft)"),
          _buildTableHeader("TVD (ft)"),
        ]),
        _buildTableRow("Surface Location", surfaceLocation),
        ...targets.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> target = entry.value;
          return _buildTableRow("Target ${index + 1}", target);
        }).toList(),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(String locationName, Map<String, String> locationData) {
    return TableRow(children: [
      _buildTableCell(locationName),
      _buildTableCell(locationData['north'] ?? 'N/A'),
      _buildTableCell(locationData['east'] ?? 'N/A'),
      _buildTableCell(locationData['tvd'] ?? 'N/A'),
    ]);
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildKOPSection(double kop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kick Off Point (KOP):",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          "${kop.toStringAsFixed(2)} feet",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMIASection(List<Map<String, double>> miaResults) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(children: [
          _buildTableHeader("Location"),
          _buildTableHeader("MD (ft)"),
          _buildTableHeader("Inclination (°)"),
          _buildTableHeader("Azimuth (°)"),
        ]),
        ...miaResults.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, double> mia = entry.value;
          return TableRow(children: [
            _buildTableCell(index == 0 ? "Surface Location" : "Target $index"),
            _buildTableCell(mia["measuredDepth"]!.toStringAsFixed(2)),
            _buildTableCell(mia["inclination"]!.toStringAsFixed(2)),
            _buildTableCell(mia["azimuth"]!.toStringAsFixed(2)),
          ]);
        }).toList(),
      ],
    );
  }

  void _exportData(List<Map<String, double>> miaResults, BuildContext context) {
    // Placeholder for exporting data logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exported data as CSV")),
    );
  }
}
