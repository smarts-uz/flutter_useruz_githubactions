import 'package:hive_flutter/hive_flutter.dart';

class ClearStorage {
  ClearStorage._();

  /// Singleton instance of [StorageModule].
  static final instance = ClearStorage._();

  final Box _localStorage = Hive.box("security_storage");
  final Box _favoriteStorage = Hive.box("favorite_storage");


  /// Clear all data in the local storage.
  void clearStorage() {
    _localStorage.clear();
    _favoriteStorage.clear();
  }
}
