import 'package:color_picker_fl/models/color_palette.dart';
import 'package:flutter/material.dart';

/// A widget that displays a grid of saved color palettes
class PaletteGrid extends StatelessWidget {
  final List<ColorPalette> palettes;
  final Function(int) onDelete;

  const PaletteGrid({Key? key, required this.palettes, required this.onDelete})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final palette = palettes[index];
        return _buildPaletteCard(palette, index);
      },
    );
  }

  /// Builds a card widget for a single palette with its colors and name
  Widget _buildPaletteCard(ColorPalette palette, int index) {
    return Card(
      elevation: 2,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Display the color strips for the palette
          Expanded(
            child: Row(
              children: palette.colors.map((color) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Display palette name and delete button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  palette.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                // Delete button to remove the palette
                IconButton(
                  icon: Icon(Icons.delete, size: 16),
                  onPressed: () => onDelete(index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
