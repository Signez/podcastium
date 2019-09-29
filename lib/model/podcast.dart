import 'package:podcastium/model/episode.dart';

class Podcast {
  /// Contain XML content from the downloaded feed.
  /// null while it is downloading.
  String rawFeedContent;

  /// Title given by the producer for this podcast, in the feed (<title>);
  String title;

  /// Description given by the producer, in the feed (<description>).
  String description;

  /// Subtitle given by the producer, in the feed (<itunes:subtitle>).
  String subtitle;

  /// Author name given by the producer, in the feed (<author>).
  String author;

  /// Copyright info given by the producer, in the feed (<copyright>).
  String copyright;

  /// Cover image given by the producer, in the feed (<image><url>).
  String imageUrl;

  /// Episodes lists loaded from the feed.
  List<Episode> episodes = [];
}
