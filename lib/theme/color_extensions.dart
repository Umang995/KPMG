import 'package:flutter/material.dart';

extension AppColors on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get lightGray => Theme.of(this).colorScheme.surface;
  Color get gray => Theme.of(this).colorScheme.onSurface;
}
