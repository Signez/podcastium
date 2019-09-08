import 'package:flutter/material.dart';
import 'package:podcastium/ui/screens/add_podcast.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: NoFeedEmptyStateWidget(),
      ),
    );
  }
}

class NoFeedEmptyStateWidget extends StatelessWidget {
  const NoFeedEmptyStateWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Vous n’avez pas encore de podcast\najouté à votre Podcastium.',
          ),
          const SizedBox(height: 10.0),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext _context) => AddPodcastScreen(),
                ),
              );
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("Ajouter un podcast…"),
          )
        ],
      ),
    );
  }
}
