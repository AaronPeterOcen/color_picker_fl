import 'dart:math';
import 'package:flutter/material.dart';

/// Represents a color palette with multiple colors and lock states
class ColorPalette {
  final List<Color> colors;
  final List<bool> lockedColor;
  final String name;
  final DateTime createdAt;

  ColorPalette({
    required this.colors,
    required this.lockedColor,
    this.name = "Untitled Palette",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Generates a random palette with 5 colors
  factory ColorPalette.generateRandom() {
    return ColorPalette(
      colors: List.generate(
        5,
        (_) =>
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      ),
      lockedColor: List.generate(5, (_) => false),
    );
  }

  /// Helper method to generate a single random color
  static Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  /// Creates a copy of this palette with optional field overrides
  ColorPalette copyWith({
    List<Color>? colors,
    List<bool>? lockedColors,
    String? name,
  }) {
    return ColorPalette(
      colors: colors ?? List.from(this.colors),
      lockedColor: lockedColors ?? List.from(this.lockedColor),
      name: name ?? this.name,
    );
  }

  /// Toggles the locked state of a color at the given index
  void lockedColors(int index) {
    lockedColor[index] = !lockedColor[index];
  }

  /// Generates new random colors for unlocked positions
  void generateNewColors() {
    for (int i = 0; i < colors.length; i++) {
      if (!lockedColor[i]) {
        colors[i] = _generateRandomColor();
      }
    }
  }

  /// Returns the hex code representation of a color at the given index
  String getColorHex(int index) {
    final color = colors[index];
    // ignore: deprecated_member_use
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }
}
