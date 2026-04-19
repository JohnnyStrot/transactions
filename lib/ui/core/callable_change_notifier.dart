import 'package:flutter/material.dart';

class CallableChangeNotifier extends ChangeNotifier {
  void change() {
    notifyListeners();
  }
}
