import 'package:flutter/material.dart';

class ScreenSizeUtil {
  double screenHeight = 0;
  double screenWidth = 0;

  // Initialize screen dimensions
  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  /// Calculate height based on a design reference height
  double getCalculateHeight(BuildContext context, double designHeight) {
    ensureInitialized(context);
    const referenceHeight = 844.0; // Replace with your design reference height
    return (designHeight * screenHeight) / referenceHeight;
  }

  /// Calculate width based on a design reference width
  double getCalculateWith(BuildContext context, double designWidth) {
    ensureInitialized(context);
    const referenceWidth = 390.0; // Replace with your design reference width
    return (designWidth * screenWidth) / referenceWidth;
  }

  /// Calculate font size based on screen size
  double calculateFontSize(BuildContext context, double designFontSize) {
    ensureInitialized(context);
    const referenceHeight = 844.0; // Replace with your design reference height
    return ((designFontSize - 2) * screenHeight) / referenceHeight;
  }

  // Ensure the utility is initialized
  void ensureInitialized(BuildContext context) {
    if (screenHeight == 0 || screenWidth == 0) {
      init(context);
    }
  }
}
