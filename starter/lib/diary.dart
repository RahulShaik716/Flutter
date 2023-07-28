import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:starter/settings.dart';
import 'package:intl/intl.dart';

class DiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiaryPage(),
      routes: {
        '/settings': (context) => SettingsPage(), // Add the settings route
      },
    );
  }
}

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  TextEditingController _textEditingController = TextEditingController();
  String _diaryEntry = '';
  String _filePath = '';

  @protected
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestStoragePermission();
    });
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission is granted. You can perform the required operation here.
    } else {
      // Permission is denied. You can handle this case accordingly.
    }
  }

  String getFormattedTimestamp() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MM_dd_HH_mm_ss');
    return formatter.format(now);
  }

  void _saveDiaryEntry() async {
    // Get the local app directory
    final directory = await getApplicationSupportDirectory();
    final subDirectory = Directory('${directory.path}/diary_log');
    if (!subDirectory.existsSync()) {
      subDirectory.createSync();
    }
    final fileName = getFormattedTimestamp();
    final file = File('${subDirectory.path}/$fileName.txt');

    // Save the diary entry to the file
    await file.writeAsString(_diaryEntry);

    // Set the file path to display to the user
    setState(() {
      _filePath = file.path;
    });

    // Show a snackbar to indicate that the entry is saved
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Diary entry saved successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/settings'); // Navigate to settings page
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        _diaryEntry = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Write your diary entry here...',
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    )),
              ),
              ElevatedButton(
                onPressed: _saveDiaryEntry,
                child: Text('Save Entry'),
              ),
              if (_filePath.isNotEmpty)
                Text(
                  'File saved at:\n$_filePath',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
