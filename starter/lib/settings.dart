import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:starter/history.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('History'),
                leading: Icon(Icons.history),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
              ),
              // Add more settings options as needed
            ],
          ),
        ],
      ),
    );
  }
}
