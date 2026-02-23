import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlist_mobile/data/prefs_storage.dart';
import 'package:movie_watchlist_mobile/viewmodels/library_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PrefsStorage storage;
  late LibraryViewModel vm;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() async {
    storage = PrefsStorage();
    vm = LibraryViewModel(storage);
    await vm.init();
  });

  group('LibraryViewModel', () {
    test('init loads empty watchlist and watched when storage is empty', () async {
      expect(vm.isReady, isTrue);
      expect(vm.watchlistIds, isEmpty);
      expect(vm.watched, isEmpty);
    });

    test('isInWatchlist returns false for any id when empty', () {
      expect(vm.isInWatchlist(1), isFalse);
    });

    test('toggleWatchlist adds then removes movie', () async {
      expect(vm.isInWatchlist(42), isFalse);
      await vm.toggleWatchlist(42);
      expect(vm.isInWatchlist(42), isTrue);
      expect(vm.watchlistIds, contains(42));
      await vm.toggleWatchlist(42);
      expect(vm.isInWatchlist(42), isFalse);
      expect(vm.watchlistIds, isEmpty);
    });

    test('isWatched returns false until movie is marked watched', () async {
      expect(vm.isWatched(10), isFalse);
      await vm.toggleWatched(10);
      expect(vm.isWatched(10), isTrue);
      expect(vm.watched.containsKey(10), isTrue);
    });

    test('removeFromWatchlist removes id without toggling', () async {
      await vm.toggleWatchlist(5);
      expect(vm.isInWatchlist(5), isTrue);
      await vm.removeFromWatchlist(5);
      expect(vm.isInWatchlist(5), isFalse);
    });

    test('persistence: watchlist survives new ViewModel init', () async {
      await vm.toggleWatchlist(1);
      await vm.toggleWatchlist(2);
      final vm2 = LibraryViewModel(storage);
      await vm2.init();
      expect(vm2.watchlistIds, containsAll([1, 2]));
    });
  });
}
