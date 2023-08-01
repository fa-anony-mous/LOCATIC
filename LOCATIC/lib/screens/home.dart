import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'about.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int numAttendees;
  final int picturesCount;

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.numAttendees,
    required this.picturesCount,
  });
}

class EventApiService {
  final String baseUrl;

  EventApiService({required this.baseUrl});

  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((data) => Event(
        name: data['name'],
        startTime: DateTime.parse(data['start_time']),
        endTime: DateTime.parse(data['end_time']),
        numAttendees: data['num_attendees'],
        picturesCount: data['pictures_count'],
      )).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _numAttendees = 10;
  List<Event> _events = [];

  final EventApiService _eventApiService = EventApiService(baseUrl: 'https://your-api-base-url.com');

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _eventApiService.getEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
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
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                event.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // You can navigate to the specific event page using event details here
                },
                child: Container(
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
                        onPressed: () {
                          setState(() {
                            _numAttendees++;
                          });
                        },
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('${event.numAttendees} people have joined this event.'),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
          }
        },
      ),
    );
  }
}
