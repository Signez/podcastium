import 'package:flutter_test/flutter_test.dart';
import 'package:podcastium/utils/feeds.dart';

void main() {
  test("detects XML header correctly", () {
    const techTwoHeader = """<?xml version="1.0" encoding="utf-8" ?>
                             <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
                                 version="2.0"
                                 xmlns:googleplay="http://www.google.com/schemas/play-podcasts/1.0"
                                 xmlns:content="http://purl.org/rss/1.0/modules/content/"
                                 xmlns:wfw="http://wellformedweb.org/CommentAPI/"
                                 xmlns:dc="http://purl.org/dc/elements/1.1/"
                                 xmlns:media="http://www.rssboard.org/media-rss">
                             <channel>
                               <title>Tech Two</title>""";

    expect(containsXmlEncoding(techTwoHeader), true);
    expect(containsXmlEncoding("""Lorem ipsum sit dolor amet"""), false);
  });

  test("understand XML header correctly", () {
    expect(parseXmlCharset('<?xml version="1.0" encoding="utf-8" ?>'), 'utf-8');
    expect(parseXmlCharset("<?xml version='1.0' encoding='utf-8' ?>"), 'utf-8');
    expect(parseXmlCharset("<?xml version='1.0' ?><html encoding=\"utf-8\">"),
        null);
  });
}
