import 'package:flutter/material.dart';
import 'package:podcastium/ui/screens/podcast.dart';

const String kProgrammeBUrl = '';

class AddPodcastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un podcast"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AddPodcastButton(
              coverImageUrl: 'https://shows.blueprint.pm/tech-two/TechTwo.jpg',
              podcastUrl:
                  'https://shows.blueprint.pm/tech-two/podcast_tech-two.xml',
              podcastTitle: 'Tech Two',
            ),
            AddPodcastButton(
              coverImageUrl:
                  'https://thumborcdn.acast.com/Xo8gkw7JAsa-dZhfKwUyy9bvE5A=/1500x1500/https://acast-media.s3.eu-west-1.amazonaws.com/assets/debd25e1-aef9-4791-b8eb-b4088df51216/1554710503262-319ca8683595c6c226b40af9019ace75.jpeg',
              podcastUrl: 'https://rss.acast.com/programme-b',
              podcastTitle: 'Programme B',
            ),
          ],
        ),
      ),
    );
  }
}

class AddPodcastButton extends StatelessWidget {
  final String podcastTitle;
  final String coverImageUrl;
  final String podcastUrl;

  const AddPodcastButton({
    this.podcastTitle,
    this.podcastUrl,
    this.coverImageUrl,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext _context) =>
                  PodcastScreen(feedUrl: podcastUrl),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PodcastCover(imageUrl: coverImageUrl),
              const SizedBox(height: 16.0),
              Text(podcastTitle),
            ],
          ),
        ),
      ),
    );
  }
}
