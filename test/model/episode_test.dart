import 'package:flutter_test/flutter_test.dart';
import 'package:podcastium/model/episode.dart';

void main() {
  test("creates an episode successfully", () {
    var episode = Episode(
      title: "Title1",
      description: "Description1",
      guid: "GUID1",
      link: "http://link1",
      pubDate: "Mon, 25 Feb 2019 10:21:00 +0100",
    );

    expect(episode.title, 'Title1');
    expect(episode.description, 'Description1');
    expect(episode.guid, 'GUID1');
    expect(episode.link, 'http://link1');
    expect(episode.pubDate.timeZoneOffset, Duration(hours: 1));
    expect(episode.pubDate.toUtc(), DateTime.utc(2019, 2, 25, 9, 21));
  });
}
