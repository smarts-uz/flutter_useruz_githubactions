// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/api_model/guest/performers/performers_filter_model.dart';

class PerformersFilterProvider with ChangeNotifier {
  PerformersFilterModel _filter = PerformersFilterModel(
    categories: [],
    childCategories: [],
    online: false,
    alphabet: false,
    review: true,
    desc: false,
    asc: true,
  );

  PerformersFilterModel _resultFilter = PerformersFilterModel(
    categories: [],
    childCategories: [],
    online: false,
    alphabet: false,
    review: true,
    desc: false,
    asc: true,
  );

  List<CategoryModel> _categories = [];
  List<List<int>> categoriesId = [];

  String _searchText = "";

  bool _allCategory = true;
  bool _loading = false;
  bool _devServer = false;
  bool _updateShown = false;

  void updateLoading(bool state) {
    _loading = state;
    notifyListeners();
  }

  void updateDialogState(bool state) {
    _updateShown = state;
    notifyListeners();
  }

  void updateAllCat(bool state) {
    _allCategory = state;
    notifyListeners();
  }

  void updateDevServer(bool value) {
    _devServer = value;
    notifyListeners();
  }

  bool get allCategory => _allCategory;
  bool get loading => _loading;
  bool get devServer => _devServer;
  bool get updateShown => _updateShown;

  PerformersFilterModel get filter => _filter;
  PerformersFilterModel get resultFilter => _resultFilter;
  String get searchText => _searchText;
  List<CategoryModel> get categories => _categories;

  void updateSearch(String text) {
    _searchText = text;
    notifyListeners();
  }

  void updateCategory(List<CategoryModel> category) {
    _categories = category;
    notifyListeners();
  }

  void updateCategoriesId(List<List<int>> category) {
    categoriesId = category;
    notifyListeners();
  }

  void updateOnline(bool state) {
    _filter.online = state;
    notifyListeners();
  }

  void updateAlphabet(bool state) {
    if (_filter.review) {
      _filter.review = !state;
      _filter.alphabet = state;
    }
    notifyListeners();
  }

  void updateReview(bool state) {
    if (_filter.alphabet) {
      _filter.alphabet = !state;
      _filter.review = state;
    }
    notifyListeners();
  }

  void updateDesc(bool state) {
    if (_filter.asc) {
      _filter.asc = !state;
      _filter.desc = state;
    }
    notifyListeners();
  }

  void updateAsc(bool state) {
    if (_filter.desc) {
      _filter.desc = !state;
      _filter.asc = state;
    }
    notifyListeners();
  }

  void resetFilter() {
    _filter = PerformersFilterModel(
      categories: [],
      childCategories: [],
      online: false,
      alphabet: false,
      review: true,
      desc: false,
      asc: true,
    );
    notifyListeners();
  }

  void setResult() {
    _resultFilter = PerformersFilterModel(
      categories: categoriesId,
      childCategories: [],
      online: _filter.online,
      alphabet: _filter.alphabet,
      review: _filter.review,
      desc: _filter.desc,
      asc: _filter.asc,
    );
    notifyListeners();
  }

  void setLast() {
    _filter = PerformersFilterModel(
      categories: [],
      childCategories: [],
      online: _resultFilter.online,
      alphabet: _resultFilter.alphabet,
      review: _resultFilter.review,
      desc: _resultFilter.desc,
      asc: _resultFilter.asc,
    );
    notifyListeners();
  }
}
