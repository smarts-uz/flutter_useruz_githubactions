import 'package:hive_flutter/hive_flutter.dart';

class StorageModule {
  /// Create a Hive box for storing security-related data.
  Future<Box> createHive() async {
    return await Hive.openBox('security_storage');
  }

  Future<Box> createFavoriteHive() async {
    return await Hive.openBox('favorite_storage');
  }
}
