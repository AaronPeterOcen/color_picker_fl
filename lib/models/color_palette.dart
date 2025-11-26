import 'dart:math';
import 'package:flutter/material.dart';

class ColorPalette {
  final List<Color> colors;
  final List<bool> lockedColors;
  final String name;
  final DateTime createdAt;

  ColorPalette({
    required this.colors,
    required this.lockedColors,
    this.name = "Untitled Palette",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Generate a random color palette
  factory ColorPalette.generateRandom() {
    return ColorPalette(
      colors: List.generate(
        5,
        (_) =>
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      ),
      lockedColors: List.generate(5, (_) => false),
    );
  }

  static Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  ColorPalette copyWith({
    List<Color>? colors,
    List<bool>? lockedColors,
    String? name,
  }) {
    return ColorPalette(
      colors: colors ?? List.from(this.colors),
      lockedColors: lockedColors ?? List.from(this.lockedColors),
      name: name ?? this.name,
    );
  }

  void lockedColor(int index) {
    lockedColors[index] = !lockedColors[index];
  }

  void generateNewColors() {
    final random = Random();
    for (int i = 0; i < colors.length; i++) {
      if (!lockedColors[i]) {
        colors[i] = _generateRandomColor();
      }
    }
  }

  String getColorHex(int index) {
    final color = colors[index];
    // ignore: deprecated_member_use
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }
}
