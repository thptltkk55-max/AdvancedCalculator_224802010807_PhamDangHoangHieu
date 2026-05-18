import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/calculation_history.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class HistoryProvider extends ChangeNotifier {
  final List<CalculationHistory> _items = [];
  int _maxItems = AppConstants.defaultHistorySize;

  List<CalculationHistory> get items => List.unmodifiable(_items);

  Future<void> loadHistory() async {
    _items
      ..clear()
      ..addAll(await StorageService.loadHistory());
    notifyListeners();
  }

  void setMaxItems(int value) {
    _maxItems = value;
    _trim();
    unawaited(StorageService.saveHistory(_items));
    notifyListeners();
  }

  Future<void> addHistory(CalculationHistory item) async {
    if (item.expression.trim().isEmpty) {
      return;
    }
    _items.insert(0, item);
    _trim();
    await StorageService.saveHistory(_items);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _items.clear();
    await StorageService.saveHistory(_items);
    notifyListeners();
  }

  void _trim() {
    if (_items.length > _maxItems) {
      _items.removeRange(_maxItems, _items.length);
    }
  }
}
