import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Info()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                6,
                    (index) => Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.grey[200],
                  child: Center(
                    child: Text("Image ${index+1}"),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.explore),
                      onPressed: () {
                        // Do something when explore icon is clicked
                      },
                    ),
                    const Text("Explore"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        // Do something when profile icon is clicked
                      },
                    ),
                    const Text("Profile"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
      ),
      body: const Center(
        child: Text("This is the Info page."),
      ),
    );
  }
}
