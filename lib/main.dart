import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:podcastium/ui/screens/HomeScreen.dart';

void main() => runApp(PodcastiumApp());

class PodcastiumApp extends StatefulWidget {
  @override
  _PodcastiumAppState createState() => _PodcastiumAppState();
}

class _PodcastiumAppState extends State<PodcastiumApp> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

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
