import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get typography => theme.textTheme;

  ColorScheme get colors => theme.colorScheme;

  bool get isDark => theme.brightness == Brightness.dark;

  bool get isLight => theme.brightness == Brightness.light;

  double get width => MediaQuery.of(this).size.width;

  bool get isSmall => width < 600;

  bool get isMedium => width >= 600 && width < 1200;

  bool get isLarge => width >= 1200;
}

extension SpacingExtension on num {
  Widget get hSpacing => SizedBox(width: this.toDouble());

  Widget get vSpacing => SizedBox(height: this.toDouble());
}
