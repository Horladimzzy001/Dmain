import 'package:flutter/material.dart';
import 'package:phidrillsim_app/ScriptProvider.dart';
import 'package:provider/provider.dart';

class DisplayScriptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String scriptContent = Provider.of<ScriptProvider>(context).scriptContent;

    return Scaffold(
      appBar: AppBar(
        title: Text('Python Script Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SelectableText(
            scriptContent,
            style: TextStyle(fontSize: 14, fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }
}
