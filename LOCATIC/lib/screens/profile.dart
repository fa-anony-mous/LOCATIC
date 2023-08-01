import 'package:flutter/material.dart';
import 'about.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Map<String, dynamic>> _imageList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImageList();
  }

  void _fetchImageList() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch image list from MongoDB database
    final response =
    await http.get(Uri.parse('https://your-mongodb-api-endpoint.com/images'));

    setState(() {
      _isLoading = false;
      _imageList = json.decode(response.body);
    });
  }

  void _deleteImage(int index) async {
    // Delete image from MongoDB database
    final response = await http.delete(
        Uri.parse('https://your-mongodb-api-endpoint.com/images/${_imageList[index]['id']}'));
    if (response.statusCode == 200) {
      setState(() {
        _imageList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locatic"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imageList.isEmpty
          ? const Center(child: Text('No images found'))
          : ListView.builder(
        itemCount: _imageList.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.network(_imageList[index]['imageUrl']),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteImage(index);
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${_imageList[index]['likes']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
