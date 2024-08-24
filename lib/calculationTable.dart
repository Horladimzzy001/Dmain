import 'package:flutter/material.dart';

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
            _buildButtons(context),
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
                Text('Northern: ${surfaceLocation["northern"]}'),
                Text('Eastern: ${surfaceLocation["eastern"]}'),
                Text('TVD: ${surfaceLocation["tvd"]}'),
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
                  Text('Northern: ${target["northern"]}'),
                  Text('Eastern: ${target["eastern"]}'),
                  Text('TVD: ${target["tvd"]}'),
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

  Widget _buildButtons(BuildContext context) {
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
              // Handle 2D Plot (to be implemented later)
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
    // Implement the Medium Curvature or Build and Hold approach here
    return 0.0; // Placeholder value, replace with actual calculation
  }

  List<Map<String, dynamic>> calculateWellPathData(double kop) {
    // Implement the Minimum Curvature method here
    return [
      {"md": 100, "inclination": 10, "azimuth": 180, "dogleg": 1.5},
      {"md": 200, "inclination": 15, "azimuth": 185, "dogleg": 1.2},
      // Add more data as needed
    ]; // Placeholder data, replace with actual calculations
  }
}
