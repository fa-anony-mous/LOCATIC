import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About The App"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Locatic is a social network app to help you socialize with events around you",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50.0),
              Text(
                "Upcoming features",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text("- Users can host events and invite their friends"),
              SizedBox(height: 8.0),
              Text("- Map UI to locate and join the events"),
              SizedBox(height: 8.0),
              Text("- More social media features like comments, sharing etc"),
              SizedBox(height: 8.0),
              Text("- Cover more events on the map"),
              SizedBox(height: 70),
              Text(
                "If you have any feedbacks or would like to join our team, mail us at locatic.company@gmail.com",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
