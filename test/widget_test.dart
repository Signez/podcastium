import 'package:flutter_test/flutter_test.dart';

import 'package:podcastium/main.dart';

void main() {
  testWidgets('App name is at least shown once', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Podcastium'), findsOneWidget);
  });
}
