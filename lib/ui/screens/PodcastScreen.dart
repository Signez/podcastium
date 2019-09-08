import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:podcastium/model/podcast.dart';
import 'package:podcastium/ui/feeds/PodcastCover.dart';
import 'package:podcastium/ui/feeds/PodcastEpisode.dart';
import 'package:podcastium/utils/FeedParser.dart';

class PodcastScreen extends StatefulWidget {
  /// URL of the podcast feed that will be described by this screen.
  final String feedUrl;

  const PodcastScreen({Key key, @required this.feedUrl}) : super(key: key);

  @override
  _PodcastScreenState createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  Podcast podcast;

  @override
  void initState() {
    super.initState();

    downloadFeed();
  }

  void downloadFeed() async {
    var response = await http.get(widget.feedUrl);

    setState(() {
      podcast = feedParser(response.bodyBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return downloadFeed();
        },
        child: CustomScrollView(slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(podcast?.title ?? 'Détail d’un podcast'),
            ),
            expandedHeight: 160.0,
          ),
          if (podcast != null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return buildHeader();
                  } else {
                    return buildSubscribeBar();
                  }
                },
                childCount: 2,
              ),
            ),
          if (podcast != null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return PodcastEpisode(episode: podcast.episodes[index]);
                },
                childCount: podcast.episodes.length,
              ),
            )
        ]),
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
          PodcastCover(imageUrl: podcast?.imageUrl),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  podcast?.author ?? "Auteur inconnu",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text(
                  podcast?.description ?? "",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                if (podcast?.copyright != null && podcast.copyright.isNotEmpty)
                  Text(
                    podcast.copyright,
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
