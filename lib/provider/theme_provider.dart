import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.yellow[800],
  buttonColor: Colors.white,
  disabledColor: Colors.white,
  fontFamily: 'OpenSansCondensed',
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.yellow[800],
  buttonColor: Colors.grey[850],
  disabledColor: Colors.grey[850],
  fontFamily: 'OpenSansCondensed',
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences prefs;
  bool _isDark;

  //getter za notifier
  bool get darkTheme => _isDark;

 
  ThemeNotifier() {
    _isDark = true;
    _loadSP();
  }

  toggleTheme() {
    _isDark = !_isDark;
    _saveSP();
    notifyListeners();
  }

  _initSP() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  _loadSP() async {
    await _initSP();
    _isDark = prefs.getBool('key') ?? false;
    notifyListeners();
  }

  _saveSP() async {
    await _initSP();
    prefs.setBool('key', _isDark);
  }


}
