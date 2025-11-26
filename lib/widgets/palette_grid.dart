import 'package:color_picker_fl/models/color_palette.dart';
import 'package:flutter/material.dart';

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

  Widget _buildPaletteCard(ColorPalette palette, int index) {
    return Card(
      elevation: 2,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  palette.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
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
