import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youdu/src/api/api_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FavoriteStorage {
  FavoriteStorage._();

  final _apiProvider = ApiProvider();

  /// Singleton instance of [StorageModule].
  static final instance = FavoriteStorage._();

  /// Local storage for favorite-related data.
  final Box _localStorage = Hive.box("favorite_storage");

  /// Getter for the user's favorite.
  bool isFavorite(int id) => _localStorage.get(id) ?? false;

  /// Save the user's favorite.
  Future<void> toggleFavorite(int id) async {
    if (isFavorite(id)) {
      final data = await _apiProvider.deleteFavoriteTask(id);
      if (data.isSuccess) {
        await _localStorage.delete(id);
      } else {
        Fluttertoast.showToast(
          msg: translate("smth_went_wrong"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      final data = await _apiProvider.createFavoriteTask(id);
      if (data.isSuccess) {
        await _localStorage.put(id, true);
      } else {
        Fluttertoast.showToast(
          msg: translate("smth_went_wrong"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  Future<void> saveFavorite(int id) async {
    await _localStorage.put(id, true);
  }
}
