import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/all.dart';

final navigationHistoryProvider = ChangeNotifierProvider<_NavigatorHistoryStore>(
      (ref) => _NavigatorHistoryStore(),
);

class _NavigatorHistoryStore extends ChangeNotifier {
  _NavigatorHistoryStore() {
    controller.addListener(push);
  }
  final CupertinoTabController controller = CupertinoTabController();

  int _prevIndex = 0;
  bool _onPop = false;
  List<int> histories = <int>[];
  bool get hasHistory => histories.isNotEmpty;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void moveTo(int index) {
    if (controller.index == index) {
      return;
    }
    controller.index = index;
  }

  void push() {
    if (_prevIndex == controller.index) {
      return;
    }
    if (_onPop) {
      _onPop = false;
    } else {
      histories.add(_prevIndex);
    }
    _prevIndex = controller.index;
    notifyListeners();
  }

  void pop() {
    _onPop = true;
    if (histories.isNotEmpty) {
      controller.index = histories.removeLast();
    }
  }
}