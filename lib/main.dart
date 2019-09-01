import 'package:flutter/material.dart';
import 'package:podcastium/ui/screens/HomeScreen.dart';

void main() => runApp(PodcastiumApp());

class PodcastiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcastium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Podcastium'),
    );
  }
}
