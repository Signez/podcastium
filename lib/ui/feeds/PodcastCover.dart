import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
