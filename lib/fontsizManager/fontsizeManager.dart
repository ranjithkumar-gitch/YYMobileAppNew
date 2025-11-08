import 'package:flutter/material.dart';

class FontSizeManager {
  static final ValueNotifier<double> fontSizeNotifier = ValueNotifier(16.0);
  static const double initialFontSize = 16.0;

  static void increaseFontSize() {
    fontSizeNotifier.value += 1.0;
  }

  static void decreaseFontSize() {
    fontSizeNotifier.value = fontSizeNotifier.value > 8.0
        ? fontSizeNotifier.value - 1.0
        : fontSizeNotifier.value; // Prevent too small sizes
  }

  static void resetFontSize() {
    fontSizeNotifier.value = initialFontSize;
  }
}
