import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podcastium/model/episode.dart';

// TODO: Handle offsets correctly.
var kHumanDateFormat = new DateFormat('EEEE dd MMM yyyy', 'fr_FR');

class PodcastEpisode extends StatelessWidget {
  final Episode episode;

  PodcastEpisode({@required this.episode, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            episode.title ?? "<Sans titre>",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          if (episode.pubDate != null)
            Text(kHumanDateFormat.format(episode.pubDate)),
          const SizedBox(height: 4.0),
          if (episode.description != null) Text(episode.description),
        ],
      ),
    );
  }
}
