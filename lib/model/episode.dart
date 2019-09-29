import 'package:intl/intl.dart';

// TODO: Handle offsets correctly.
var kRSSDateFormat = new DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');

class Episode {
  Episode(
      {this.title,
      this.link,
      this.guid,
      this.description,
      this.subtitle,
      pubDate}) {
    try {
      this.pubDate = kRSSDateFormat.parse(pubDate ?? "");
    } catch (FormatException) {
      this.pubDate = null;
    }
  }

  /// Title of the episode (<title>).
  final String title;

  /// Link to a webpage describing the episode (<link>).
  final String link;

  /// Global, unique ID for this episode (<guid>).
  final String guid;

  /// Publication date for this episode (<pubDate>).
  DateTime pubDate;

  /// Description for this episode (<description>).
  final String description;

  /// Sub-title (short description) for this episode (<itunes:subtitle>).
  final String subtitle;
}
