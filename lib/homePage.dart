import 'package:flutter/material.dart';
import 'calculationTable.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _kopEnabled = false;
  Map<String, TextEditingController> _surfaceLocation = {
    "northern": TextEditingController(),
    "eastern": TextEditingController(),
    "tvd": TextEditingController(),
  };
  List<Map<String, TextEditingController>> _targets = [];
  TextEditingController _kopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize _targets with a default target location
    _targets.add({
      "northern": TextEditingController(),
      "eastern": TextEditingController(),
      "tvd": TextEditingController(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhiDrillSim"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Input"),
            Tab(text: "View Data"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInputTab(),
          CalculationTable(
            surfaceLocation: {
              "northern": _surfaceLocation["northern"]!.text,
              "eastern": _surfaceLocation["eastern"]!.text,
              "tvd": _surfaceLocation["tvd"]!.text,
            },
            targets: _targets.map((target) {
              return {
                "northern": target["northern"]!.text,
                "eastern": target["eastern"]!.text,
                "tvd": target["tvd"]!.text,
              };
            }).toList(),
            kopEnabled: _kopEnabled,
            kopValue: double.tryParse(_kopController.text) ?? 0.0,
          )
        ],
      ),
    );
  }

  Widget _buildInputTab() {
    return SingleChildScrollView(  // Enable vertical scrolling
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Surface Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Northern')),
                  DataColumn(label: Text('Eastern')),
                  DataColumn(label: Text('TVD')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(TextField(
                      controller: _surfaceLocation["northern"],
                      decoration: InputDecoration(
                        labelText: "Northern (Surface)",
                      ),
                      keyboardType: TextInputType.number,
                    )),
                    DataCell(TextField(
                      controller: _surfaceLocation["eastern"],
                      decoration: InputDecoration(
                          labelText: "Eastern (Surface)"),
                      keyboardType: TextInputType.number,
                    )),
                    DataCell(TextField(
                      controller: _surfaceLocation["tvd"],
                      decoration: InputDecoration(
                          labelText: "TVD (Surface)"),
                      keyboardType: TextInputType.number,
                    )),
                    DataCell(Container()), // No delete button for surface location
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Add padding between sections
              child: Text(
                'Target Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: _targets.map((location) {
                int index = _targets.indexOf(location);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Northern')),
                        DataColumn(label: Text('Eastern')),
                        DataColumn(label: Text('TVD')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(TextField(
                            controller: location["northern"],
                            decoration: InputDecoration(
                                labelText: "Northern (Target)"),
                            keyboardType: TextInputType.number,
                          )),
                          DataCell(TextField(
                            controller: location["eastern"],
                            decoration: InputDecoration(
                                labelText: "Eastern (Target)"),
                            keyboardType: TextInputType.number,
                          )),
                          DataCell(TextField(
                            controller: location["tvd"],
                            decoration: InputDecoration(
                                labelText: "TVD (Target)"),
                            keyboardType: TextInputType.number,
                          )),
                          DataCell(IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeLocation(index),
                          )),
                        ]),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Enable KOP:"),
                Switch(
                  value: _kopEnabled,
                  onChanged: (value) {
                    setState(() {
                      _kopEnabled = value;
                      if (!_kopEnabled) _kopController.clear();
                    });
                  },
                ),
              ],
            ),
            if (_kopEnabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _kopController,
                  decoration: InputDecoration(
                    labelText: "Kick Off Point",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            // Centering the "Add Target Location" button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _addLocation,
                  icon: Icon(Icons.add),
                  label: Text("Add Target Location"),
                ),
              ),
            ),
            // Centering the "Data" button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Switch to the "View Data" tab
                    setState(() {
                      _tabController.index = 1;
                    });
                  },
                  child: Text("Data"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addLocation() {
    setState(() {
      Map<String, TextEditingController> newLocation = {
        "northern": TextEditingController(),
        "eastern": TextEditingController(),
        "tvd": TextEditingController(),
      };
      _targets.add(newLocation);
    });
  }

  void _removeLocation(int index) {
    setState(() {
      _targets.removeAt(index);
    });
  }
}
