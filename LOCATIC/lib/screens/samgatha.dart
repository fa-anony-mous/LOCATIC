import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mongo_dart/mongo_dart.dart' as mn;

import 'about.dart';

class SamgathaPage extends StatefulWidget {
  const SamgathaPage({Key? key}) : super(key: key);

  @override
  _SamgathaPageState createState() => _SamgathaPageState();
}

class _SamgathaPageState extends State<SamgathaPage> {
  static const _pageSize = 20;
  final PagingController<int, Map<String, dynamic>> _pagingController =
  PagingController(firstPageKey: 0);
  final mn.Db _db = mn.Db('mongodb://localhost:27017/testdb');

  @override
  void initState() {
    _db.open().then((_) {
      _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
      });
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final data = await _db
          .collection('photos')
          .find()
          .skip(pageKey * _pageSize)
          .take(_pageSize)
          .toList();

      final newItems = data.map((e) => e).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _uploadImage() async {
    // Show the file picker to let the user select an image file
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    // Upload the selected image to the database
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final doc = {
        'image': Uint8List.fromList(bytes),
        'likes': 0,
      };
      await _db.collection('photos').insert(doc);
      _pagingController.refresh();
    }
  }

  Future<void> _likePhoto(String id, item) async {
    // Update the likes count of the specified photo document
    final photo = await _db.collection('photos').findOne({'_id': mn.ObjectId.parse(id)});
    final likes = photo!['likes'] + 1;
    await _db.collection('photos').update(
      {'_id': mn.ObjectId.parse(id)},
      {'\$set': {'likes': likes}},
    );
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOCATIC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
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
    child: PagedListView<int, Map<String, dynamic>>(
    pagingController: _pagingController,
    builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
    itemBuilder: (context, item, index) => GestureDetector(
    onTap: () {
    // Navigate to the photo details page.
    },
    child: Container(
    margin: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Image.memory(
    item['image'].data,
    height: 150.0,
    ),
    const SizedBox(height: 8.0),
    Row(
    children: [
    GestureDetector(
    onTap: () {
    // Like the photo.
    setState(() {
    item['likes'] = item['likes'] + 1;
    });
    final id = item['_id'].toHexString();
    final likes = item['likes'];
    _db
        .collection('photos')
        .update({'_id': mn.ObjectId.fromHexString(id)}, {'\$set': {'likes': likes}});
    },
    onDoubleTap: () {
    _likePhoto(item['_id'].toHexString(), item['likes']);
    },
    child: const Icon(
    Icons.favorite_border,
    size: 24.0,
    ),
    ),
    const SizedBox(width: 8.0),
    Text(
    '${item['likes']} likes',
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    ),
    )
    ),
    ]
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: _uploadImage,
    tooltip: 'Upload Image',
    child: const Icon(Icons.add_a_photo),
    ),
    );
  }
}

