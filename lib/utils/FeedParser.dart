import 'dart:convert';
import 'dart:typed_data';

import 'package:podcastium/model/episode.dart';
import 'package:podcastium/model/podcast.dart';
import 'package:webfeed/webfeed.dart';

Podcast feedParser(Uint8List bytesFeedContent) {
  Podcast podcast = Podcast();

  // TODO: Detect encoding here using simple RegExp (for <?xml)
  var encoding = Encoding.getByName('utf-8');
  podcast.rawFeedContent = encoding.decode(bytesFeedContent);

  // First, parsing it in a non-business way to get the right encoding
  /* var xmlFeed = xml.parse(body);
  var xmlFirstNode = xmlFeed.firstChild;

  if (xmlFirstNode != null &&
      xmlFirstNode.nodeType == xml.XmlNodeType.PROCESSING &&
      bytesFeedContent.length > 0) {
    var matches = RegExp("encoding=\"(.+?)\"").allMatches(xmlFirstNode.text);
    for (Match match in matches) {
      var encodingName = match.group(1);
      var encoding = Encoding.getByName(encodingName);

      if (encoding != null) {
        podcast.rawFeedContent = encoding.decode(bytesFeedContent);
      } else {
        debugPrint("WARN: encoding $encodingName is unknown.");
      }
    }
  } */

  var feed = RssFeed.parse(podcast.rawFeedContent);

  podcast.title = feed.title;
  podcast.description = feed.description;
  podcast.author = feed.itunes?.author ?? feed.author;
  podcast.copyright = feed.copyright;
  podcast.imageUrl = feed.image?.url;

  podcast.episodes = feed.items
      .map(
        (item) => Episode(
          title: item.title,
          description: item.description,
          guid: item.guid,
          link: item.link,
          pubDate: item.pubDate,
        ),
      )
      .toList();

  return podcast;
}
