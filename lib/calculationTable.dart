import 'package:flutter/material.dart';
import '2d_plot.dart';
import "dart:math";

class CalculationTable extends StatelessWidget {
  final Map<String, String> surfaceLocation;
  final List<Map<String, String>> targets;
  final bool kopEnabled;
  final double kopValue;

  CalculationTable({
    required this.surfaceLocation,
    required this.targets,
    required this.kopEnabled,
    required this.kopValue,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure that surfaceLocation and targets are not null or empty
    if (surfaceLocation.isEmpty) {
      return Center(
        child: Text('Error: Surface location data is missing.'),
      );
    }
    
    if (targets.isEmpty) {
      return Center(
        child: Text('Error: Target data is missing.'),
      );
    }

    // Calculate KOP if not provided
    double calculatedKop = kopEnabled ? kopValue : calculateKOP();

    // Calculate measured depths, inclinations, azimuths, etc.
    List<Map<String, dynamic>> calculatedData = calculateWellPathData(calculatedKop);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Table 1: Surface and Target Locations
            _buildSurfaceAndTargetLocationsTable(),
            SizedBox(height: 32),
            // Table 2: KOP and Well Path Data
            _buildKopAndWellPathTable(calculatedKop, calculatedData),
            SizedBox(height: 32),
            // Buttons
            _buildButtons(context, calculatedKop, calculatedData),
          ],
        ),
      ),
    );
  }

  Widget _buildSurfaceAndTargetLocationsTable() {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FixedColumnWidth(150),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(children: [
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Surface Location'),
          )),
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Northern: ${surfaceLocation["northern"] ?? "0"}'),
                Text('Eastern: ${surfaceLocation["eastern"] ?? "0"}'),
                Text('TVD: ${surfaceLocation["tvd"] ?? "0"}'),
              ],
            ),
          )),
        ]),
        ...targets.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> target = entry.value;
          return TableRow(children: [
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Target Location ${index + 1}'),
            )),
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Northern: ${target["northern"] ?? "0"}'),
                  Text('Eastern: ${target["eastern"] ?? "0"}'),
                  Text('TVD: ${target["tvd"] ?? "0"}'),
                ],
              ),
            )),
          ]);
        }).toList(),
      ],
    );
  }

  Widget _buildKopAndWellPathTable(double kop, List<Map<String, dynamic>> data) {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FixedColumnWidth(100),
        1: FixedColumnWidth(100),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(100),
      },
      children: [
        TableRow(children: [
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('KOP'),
          )),
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('$kop m'),
          )),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Measured Depth (MD)'),
          )),
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Inclination'),
          )),
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Azimuth'),
          )),
          TableCell(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Dogleg'),
          )),
        ]),
        ...data.map((row) {
          return TableRow(children: [
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('${row["md"]} m'),
            )),
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('${row["inclination"]}°'),
            )),
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('${row["azimuth"]}°'),
            )),
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('${row["dogleg"]}°/100ft'),
            )),
          ]);
        }).toList(),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, double kop, List<Map<String, dynamic>> data) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle export data
            },
            child: Text("Export Data"),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to the 2D Plot screen and pass the calculated data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Plot2D(data: data),
                ),
              );
            },
            child: Text("2D Plot"),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle 3D Plot (to be implemented later)
            },
            child: Text("3D Plot"),
          ),
        ],
      ),
    );
  }

  double calculateKOP() {
  // Helper function to safely parse double values and ensure they are not null
  double parseOrDefault(String? value, double defaultValue) {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    return double.tryParse(value) ?? defaultValue;
  }

  // Retrieve surface location coordinates with default values (in feet)
  double surfaceNorth = parseOrDefault(surfaceLocation["northern"], 0.0);
  double surfaceEast = parseOrDefault(surfaceLocation["eastern"], 0.0);
  double surfaceTVD = parseOrDefault(surfaceLocation["tvd"], 0.0);

  double kop = surfaceTVD; // Initialize KOP with the surface TVD (in feet)

  for (Map<String, String> target in targets) {
    double targetNorth = parseOrDefault(target["northern"], surfaceNorth);
    double targetEast = parseOrDefault(target["eastern"], surfaceEast);
    double targetTVD = parseOrDefault(target["tvd"], surfaceTVD);

    // Calculate the differences
    double deltaNorth = targetNorth - surfaceNorth;
    double deltaEast = targetEast - surfaceEast;
    double deltaTVD = targetTVD - surfaceTVD;

    // Calculate horizontal displacement (HD)
    double HD = sqrt(deltaNorth * deltaNorth + deltaEast * deltaEast);

    // Calculate inclination angle (theta) in degrees
    double theta = atan(HD / deltaTVD) * (180 / pi);

    // Calculate azimuth angle (phi) in degrees
    double phi = atan(deltaEast / deltaNorth) * (180 / pi);

    // Determine if this target results in a significant inclination change
    if (theta > 0) {
      kop = surfaceTVD; // Set KOP to the current TVD (or the corresponding MD in feet)
      break; // Exit the loop once a significant change is detected
    }
  }

  return kop; // The KOP value is guaranteed to be a non-nullable double in feet
}

  List<Map<String, dynamic>> calculateWellPathData(double kop, double interval) {
  // Prepare the combined list of surface and target locations
  List<Map<String, double>> locations = [
    {
      "northern": double.parse(surfaceLocation["northern"]!),
      "eastern": double.parse(surfaceLocation["eastern"]!),
      "tvd": double.parse(surfaceLocation["tvd"]!)
    },
    ...targets.map((target) => {
      "northern": double.parse(target["northern"]!),
      "eastern": double.parse(target["eastern"]!),
      "tvd": double.parse(target["tvd"]!)
    }).toList()
  ];

  List<Map<String, dynamic>> results = [];

  for (int i = 0; i < locations.length - 1; i++) {
    double startNorth = locations[i]["northern"]!;
    double startEast = locations[i]["eastern"]!;
    double startTVD = locations[i]["tvd"]!;
    double endNorth = locations[i + 1]["northern"]!;
    double endEast = locations[i + 1]["eastern"]!;
    double endTVD = locations[i + 1]["tvd"]!;

    double deltaN = endNorth - startNorth;
    double deltaE = endEast - startEast;
    double deltaTVD = endTVD - startTVD;

    double totalDistance = sqrt(deltaN * deltaN + deltaE * deltaE + deltaTVD * deltaTVD);
    int numPoints = (totalDistance / interval).ceil();

    for (int j = 0; j <= numPoints; j++) {
      double fraction = j / numPoints;
      double md = sqrt(
        pow(startNorth + fraction * deltaN, 2) +
        pow(startEast + fraction * deltaE, 2) +
        pow(startTVD + fraction * deltaTVD, 2)
      );

      double currentNorth = startNorth + fraction * deltaN;
      double currentEast = startEast + fraction * deltaE;
      double currentTVD = startTVD + fraction * deltaTVD;

      double HD = sqrt(pow(currentNorth - startNorth, 2) + pow(currentEast - startEast, 2));
      double inclination = atan2(HD, currentTVD - startTVD) * (180 / pi);
      double azimuth = atan2(currentEast - startEast, currentNorth - startNorth) * (180 / pi);
      if (azimuth < 0) {
        azimuth += 360; // Ensure azimuth is in the range [0, 360)
      }

      double dogleg = 0;
      if (results.isNotEmpty) {
        double previousInclination = results.last["inclination"];
        double previousAzimuth = results.last["azimuth"];
        dogleg = sqrt(
          pow(inclination - previousInclination, 2) +
          pow(azimuth - previousAzimuth, 2)
        );
      }

      results.add({
        "md": md,
        "inclination": inclination,
        "azimuth": azimuth,
        "dogleg": dogleg
      });
    }
  }

  return results;
}


}
