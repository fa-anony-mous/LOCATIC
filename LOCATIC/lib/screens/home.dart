import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'about.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int joinCount;

  Event({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.joinCount,
  });
}

class EventApiService {
  final String baseUrl;

  EventApiService({required this.baseUrl});

  Future<List<Event>> getEvents({required String filter}) async {
    final response = await http.get(Uri.parse('$baseUrl?filter=$filter'));
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      final List<dynamic> eventsData = jsonData['events'];
      return eventsData.map((data) => Event(
        name: data['name'],
        startDate: DateTime.parse(data['start_date']),
        endDate: DateTime.parse(data['end_date']),
        joinCount: data['join_count'],
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
  String _selectedFilter = 'upcoming';
  int _numAttendees = 10;
  List<Event> _events = [];

  final EventApiService _eventApiService = EventApiService(baseUrl: 'http://172.17.2.6:8000/events?filter=past');

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _eventApiService.getEvents(filter: _selectedFilter);
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
        title: const Text('Events List'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: [
                DropdownMenuItem(
                  value: 'past',
                  child: Text('Past'),
                ),
                DropdownMenuItem(
                  value: 'ongoing',
                  child: Text('Ongoing'),
                ),
                DropdownMenuItem(
                  value: 'upcoming',
                  child: Text('Upcoming'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  _fetchEvents();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(event: event),
                          ),
                        );
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
                    Text('${event.joinCount} people have joined this event.'),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
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

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Date: ${event.startDate}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'End Date: ${event.endDate}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Number of Attendees: ${event.joinCount}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Add more event details as needed
          ],
        ),
      ),
    );
  }
}
