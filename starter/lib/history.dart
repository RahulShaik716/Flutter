import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _fileNames = [];

  @override
  void initState() {
    super.initState();
    _loadFileNames();
  }

  Future<void> _loadFileNames() async {
    final directory = await getApplicationSupportDirectory();
    final subDirectory = Directory('${directory.path}/diary_log');
    List<FileSystemEntity> files = subDirectory.listSync();
    List<String> fileNames = [];
    for (FileSystemEntity file in files) {
      if (file is File) {
        fileNames.add(file.path.split('/').last);
      }
    }
    setState(() {
      _fileNames = fileNames;
    });
  }

  Future<void> _showFileContent(String fileName) async {
    final directory = await getApplicationSupportDirectory();
    final subDirectory = Directory('${directory.path}/diary_log');
    final file = File('${directory.path}/$fileName');
    String content = await file.readAsString();

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fileName),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: _fileNames.length,
        itemBuilder: (context, index) {
          final fileName = _fileNames[index];
          return ListTile(
            title: Text(fileName),
            onTap: () => _showFileContent(fileName),
          );
        },
      ),
    );
  }
}
