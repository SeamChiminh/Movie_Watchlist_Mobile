import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlist_mobile/data/asset_movie_repository.dart';
import 'package:movie_watchlist_mobile/data/prefs_storage.dart';
import 'package:movie_watchlist_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts and shows splash then login', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      repository: AssetMovieRepository(),
      storage: PrefsStorage(),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('Login'), findsAtLeast(1));
  });
}
