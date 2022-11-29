import 'package:flutter/material.dart';

abstract class Tema {
  bool _isLightThemed = true;

  static const Color blue = Color(0xff4288E8);
  static const Color darkBlue = Color(0xff1D0B6B);
  static const Color yellow = Color(0xffFDDA48);
  static const Color red = Color(0xffE9163D);

  static final ThemeData light = ThemeData.light().copyWith(
    colorScheme: light.colorScheme.copyWith(),
  );

  static final ThemeData dark = ThemeData.dark().copyWith();

  ThemeData get theme {
    if (_isLightThemed) return light;
    return dark;
  }

  void toggleTheme() {
    _isLightThemed = !_isLightThemed;
  }
}
