import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:podcastium/model/episode.dart';
import 'package:podcastium/ui/feeds/PodcastCover.dart';
import 'package:podcastium/ui/feeds/PodcastEpisode.dart';
import 'package:xml/xml.dart' as xml;
import 'package:webfeed/webfeed.dart';
import 'dart:convert';

class PodcastScreen extends StatefulWidget {
  /// URL of the podcast feed that will be described by this screen.
  final String feedUrl;

  const PodcastScreen({Key key, @required this.feedUrl}) : super(key: key);

  @override
  _PodcastScreenState createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  /// Contain XML content from the downloaded feed.
  /// null while it is downloading.
  String rawFeedContent;

  /// Title given by the producer for this podcast, in the feed (<title>);
  String feedTitle;

  /// Description given by the producer, in the feed (<description>).
  String feedDescription;

  /// Author name given by the producer, in the feed (<author>).
  String feedAuthor;

  /// Copyright info given by the producer, in the feed (<copyright>).
  String feedCopyright;

  /// Cover image given by the producer, in the feed (<image><url>).
  String feedImageUrl;

  /// Episodes lists loaded from the feed.
  List<Episode> episodes = [];

  @override
  void initState() {
    super.initState();

    downloadFeed();
  }

  void downloadFeed() async {
    var response = await http.get(widget.feedUrl);

    setState(() {
      rawFeedContent = response.body;
    });

    parseFeed(response.body, response.bodyBytes);
  }

  void parseFeed(String textFeedContent,
      [List<int> bytesFeedContent = const []]) {
    // First, parsing it in a non-business way to get the right encoding
    var xmlFeed = xml.parse(rawFeedContent);
    var xmlFirstNode = xmlFeed.firstChild;

    if (xmlFirstNode != null &&
        xmlFirstNode.nodeType == xml.XmlNodeType.PROCESSING &&
        bytesFeedContent.length > 0) {
      var matches = RegExp("encoding=\"(.+?)\"").allMatches(xmlFirstNode.text);
      for (Match match in matches) {
        var encodingName = match.group(1);
        var encoding = Encoding.getByName(encodingName);
        if (encoding != null) {
          rawFeedContent = encoding.decode(bytesFeedContent);
        } else {
          debugPrint("WARN: encoding $encodingName is unknown.");
        }
      }
    }

    var feed = RssFeed.parse(rawFeedContent);

    setState(() {
      feedTitle = feed.title;
      feedDescription = feed.description;
      feedAuthor = feed.author;
      feedCopyright = feed.copyright;
      feedImageUrl = feed.image.url;
      episodes = feed.items
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feedTitle ?? 'Détail d’un podcast'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return downloadFeed();
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return buildHeader();
            } else if (index == 1) {
              return buildSubscribeBar();
            } else {
              return PodcastEpisode(episode: episodes[index - 2]);
            }
          },
          itemCount: episodes.length + 2,
        ),
      ),
    );
  }

  Center buildSubscribeBar() {
    return Center(
      child: Text(
        widget.feedUrl,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          PodcastCover(imageUrl: feedImageUrl),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedAuthor ?? "Auteur inconnu",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text(
                  feedDescription ?? "",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                if (feedCopyright != null && feedCopyright.isNotEmpty)
                  Text(
                    feedCopyright,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
