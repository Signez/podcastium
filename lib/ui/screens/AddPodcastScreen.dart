import 'package:flutter/material.dart';
import 'package:podcastium/ui/screens/PodcastScreen.dart';

const String kTechTwoUrl =
    'https://shows.blueprint.pm/tech-two/podcast_tech-two.xml';

class AddPodcastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un podcast"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext _context) =>
                    PodcastScreen(feedUrl: kTechTwoUrl),
              ),
            );
          },
          child: Text("Ajouter Tech Two"),
        ),
      ),
    );
  }
}
