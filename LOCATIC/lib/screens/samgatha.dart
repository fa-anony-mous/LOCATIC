import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SamgathaPage extends StatefulWidget {
  const SamgathaPage({Key? key}) : super(key: key);

  @override
  _SamgathaPageState createState() => _SamgathaPageState();
}

class _SamgathaPageState extends State<SamgathaPage> {
  List<File> _images = [];

  Future<void> _uploadPhotos() async {
    final picker = ImagePicker();
    final permissionResult = await Permission.photos.request();

    if (permissionResult.isGranted) {
      final selectedImages = await picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _images = selectedImages.map((image) => File(image.path)).toList();
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Gallery permission denied'),
            content: const Text('Please grant permission to access gallery.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOCATIC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Samgatha',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _images[index],
                    height: 150.0,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _uploadPhotos,
              child: const Text('Upload Photos'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.explore),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
