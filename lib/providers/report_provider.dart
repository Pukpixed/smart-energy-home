import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  bool generating = false;

  Future<void> generateReport() async {
    generating = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    generating = false;
    notifyListeners();
  }
}
