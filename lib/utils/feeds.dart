import 'dart:convert';
import 'dart:typed_data';

import 'package:podcastium/model/episode.dart';
import 'package:podcastium/model/podcast.dart';
import 'package:webfeed/webfeed.dart';

bool containsXmlEncoding(String podcastFeedHead) {
  return podcastFeedHead
      .contains(RegExp(r"<\?xml[^>]+encoding", caseSensitive: false));
}

String parseXmlCharset(String podcastFeedHead) {
  var regex = RegExp('<\\?xml[^>]+encoding=(\'|")?([-A-Za-z0-9._]+)',
      caseSensitive: false);
  var matches = regex.allMatches(podcastFeedHead);

  for (var match in matches) {
    return match.group(2);
  }

  return null;
}

Podcast feedParser(String feedContent, Uint8List bytesFeedContent) {
  Podcast podcast = Podcast();

  var firstBytes = bytesFeedContent.sublist(0, 128);
  var podcastFeedHead = Encoding.getByName('ascii').decode(firstBytes);

  if (containsXmlEncoding(podcastFeedHead)) {
    var charset = parseXmlCharset(podcastFeedHead) ?? 'utf-8';
    var encoding = Encoding.getByName(charset);

    if (encoding != null) {
      podcast.rawFeedContent = encoding.decode(bytesFeedContent);
    } else {
      podcast.rawFeedContent = feedContent;
    }
  } else {
    podcast.rawFeedContent = feedContent;
  }

  var feed = RssFeed.parse(podcast.rawFeedContent);

  podcast.title = feed.title;
  podcast.description = feed.description;
  podcast.author = feed.itunes?.author ?? feed.author;
  podcast.copyright = feed.copyright;
  podcast.imageUrl = feed.image?.url;
  podcast.subtitle = feed.itunes?.subtitle;

  podcast.episodes = feed.items
      .map(
        (item) => Episode(
          title: item.title,
          description: item.description,
          guid: item.guid,
          link: item.link,
          pubDate: item.pubDate,
          subtitle: item.itunes.subtitle,
        ),
      )
      .toList();

  return podcast;
}
