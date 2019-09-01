import 'package:flutter/material.dart';
import 'package:podcastium/ui/screens/AddPodcastScreen.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
