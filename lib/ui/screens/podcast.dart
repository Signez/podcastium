import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:podcastium/model/episode.dart';
import 'package:podcastium/model/podcast.dart';
import 'package:podcastium/utils/feeds.dart';
import 'package:transparent_image/transparent_image.dart';

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
                    return PodcastHeader(podcast: podcast);
                  } else {
                    return PodcastSubscribeBar(widget: widget);
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
}

class PodcastSubscribeBar extends StatelessWidget {
  const PodcastSubscribeBar({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final PodcastScreen widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        widget.feedUrl,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class PodcastHeader extends StatelessWidget {
  const PodcastHeader({
    Key key,
    @required this.podcast,
  }) : super(key: key);

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
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

class PodcastCover extends StatefulWidget {
  final String imageUrl;

  const PodcastCover({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _PodcastCoverState createState() => _PodcastCoverState();
}

class _PodcastCoverState extends State<PodcastCover> {
  String coverImageUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshCoverUrl() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const kRadius = BorderRadius.all(Radius.circular(20.0));

    return Container(
      width: 128.0,
      height: 128.0,
      child: Material(
        color: Colors.blue,
        borderRadius: kRadius,
        child: InkWell(
          borderRadius: kRadius,
          onTap: () {
            refreshCoverUrl();
          },
          child: ClipRRect(
            borderRadius: kRadius,
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.rss_feed, color: Colors.white, size: 50.0),
                ),
                if (widget.imageUrl != null)
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.imageUrl,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
