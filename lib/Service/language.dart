import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  Map languageData;
  LanguageService(this.languageData);
  getLanguage() => languageData;
  setLanguage(Map language) {
    languageData = language;
    notifyListeners();
  }
}
