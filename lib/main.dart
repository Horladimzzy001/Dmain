import 'package:flutter/material.dart';
import 'package:phidrillsim_app/calculationTable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhiDrillSim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
  'assets/drill_logo.jpg',  // Replace with the path to your image
  fit: BoxFit.contain,         // This will make the image cover the entire screen
  height: MediaQuery.of(context).size.height,  // Match the height of the screen
  width: MediaQuery.of(context).size.width,    // Match the width of the screen
),

    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _kopEnabled = false;
  List<Map<String, TextEditingController>> _locations = [{}];
  TextEditingController _kopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _locations[0]["northern"] = TextEditingController();
    _locations[0]["eastern"] = TextEditingController();
    _locations[0]["tvd"] = TextEditingController();

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
            CalculationTable() // Placeholder for the second tab
        ],
      ),
    );
  }

  Widget _buildInputTab() {
  return ListView(
    children: <Widget>[
      // Add the Surface Location Label
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Surface Location',  // This text marks the surface location
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      
      // DataTable for Surface Location
      DataTable(
        columns: [
          DataColumn(label: Text('Northern')),
          DataColumn(label: Text('Eastern')),
          DataColumn(label: Text('TVD')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(TextField(
                controller: _locations[0]["northern"],
                decoration: InputDecoration(
                    labelText: "Northern (Surface)"))),
            DataCell(TextField(
                controller: _locations[0]["eastern"],
                decoration: InputDecoration(
                    labelText: "Eastern (Surface)"))),
            DataCell(TextField(
                controller: _locations[0]["tvd"],
                decoration: InputDecoration(
                    labelText: "TVD (Surface)"))),
            DataCell(Container()), // No delete button for surface location
          ]),
        ],
      ),

      // Add the Target Location Label
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Target Location',  // This text marks the target location
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      
      // DataTable for Target Locations
      DataTable(
        columns: [
          DataColumn(label: Text('Northern')),
          DataColumn(label: Text('Eastern')),
          DataColumn(label: Text('TVD')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _locations.skip(1).map((location) { // Skipping the first location
          int index = _locations.indexOf(location);
          return DataRow(cells: [
            DataCell(TextField(
                controller: location["northern"],
                decoration: InputDecoration(
                    labelText: "Northern (Target)"))),
            DataCell(TextField(
                controller: location["eastern"],
                decoration: InputDecoration(
                    labelText: "Eastern (Target)"))),
            DataCell(TextField(
                controller: location["tvd"],
                decoration: InputDecoration(
                    labelText: "TVD (Target)"))),
            DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeLocation(index))),
          ]);
        }).toList(),
      ),
      
      // Remaining widgets
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
              labelText: "KOP",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton.icon(
          onPressed: _addLocation,
          icon: Icon(Icons.add),
          label: Text("Add Target Location"),
        ),
      ),
    ],
  );
}




  void _addLocation() {
    setState(() {
      Map<String, TextEditingController> newLocation = {
        "northern": TextEditingController(),
        "eastern": TextEditingController(),
        "tvd": TextEditingController(),
      };
      _locations.add(newLocation);
    });
  }

  void _removeLocation(int index) {
    setState(() {
      _locations.removeAt(index);
    });
  }
}
