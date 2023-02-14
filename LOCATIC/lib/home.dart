import 'package:flutter/material.dart';
import 'about.dart';
import 'profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOCATIC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'SAMGATHA',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Join the event'),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Join'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
      ),
    );
  }
}
