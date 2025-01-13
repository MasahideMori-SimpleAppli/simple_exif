import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_exif/simple_exif.dart';

void main() async {
  runApp(const AppParent(MyApp()));
}

class AppParent extends StatelessWidget {
  final Widget child;

  const AppParent(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? _imageData;
  final List<String> _exifData = [];

  // create Exif data list view.
  Widget _getExifDataList() {
    if (_exifData.isEmpty) {
      return const SizedBox();
    } else {
      return Expanded(
          child: Container(
              margin: const EdgeInsets.all(8),
              color: Colors.blue[50]!,
              child: ListView.builder(
                itemCount: _exifData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_exifData[index]),
                  );
                },
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Exif"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 240,
                  height: 320,
                  margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                  child: _imageData != null
                      ? Image.memory(
                          _imageData!,
                          fit: BoxFit.contain,
                        )
                      : const Center(child: Text("No image"))),
              ElevatedButton(
                onPressed: () async {
                  final p = ImagePicker();
                  XFile? f = await p.pickMedia();
                  if (f != null) {
                    _exifData.clear();
                    _imageData = await f.readAsBytes();
                    if (_imageData != null) {
                      setState(() {
                        final reader = ExifReader(_imageData!);
                        for (ExifTag i in reader.getCopiedAllTags()) {
                          _exifData.add(i.toDict().toString());
                        }
                      });
                    }
                  }
                },
                child: const Text('Choice the image'),
              ),
              const SizedBox(
                height: 12,
              ),
              _getExifDataList(),
            ],
          ))
        ],
      ),
    );
  }
}
