// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:color_picker_fl/models/color_palette.dart';
import 'package:color_picker_fl/widgets/color_card.dart';
import 'package:color_picker_fl/widgets/palette_grid.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ColorPalette> _palettes = [];
  ColorPalette _currentPalette = ColorPalette.generateRandom();

  @override
  void initState() {
    super.initState();
    _loadSavedPalettes();
  }

  void _loadSavedPalettes() {
    setState(() {
      _palettes = [
        ColorPalette.generateRandom(),
        ColorPalette.generateRandom(),
      ];
    });
  }

  void _generateNewPalette() {
    setState(() {
      _currentPalette = ColorPalette.generateRandom();
    });
  }

  void _lockColor(int index) {
    setState(() {
      _currentPalette.lockedColor(index); //check this
    });
  }

  void _savePalette() {
    setState(() {
      _palettes.add(_currentPalette.copyWith());
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Palette saved!')));
  }

  // void _deletePalette(int index) {
  //   setState(() {
  //     _palettes.removeAt(index);
  //   });
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('Palette deleted!')));
  // }
  void _deletePalette(int index) {
    if (index < 0 || index >= _palettes.length) return;

    setState(() {
      // This forces a complete rebuild of the list
      _palettes = List<ColorPalette>.from(_palettes)..removeAt(index);
    });
  }
  // void _deletePalette(int index) {
  //   print('Delete called with index: $index');
  //   print('Current palettes length: ${_palettes.length}');

  //   if (_palettes.isEmpty) {
  //     print('Palettes list is empty');
  //     return;
  //   }

  //   if (index < 0 || index >= _palettes.length) {
  //     print('Invalid index: $index');
  //     return;
  //   }

  //   setState(() {
  //     _palettes.removeAt(index);
  //   });
  //   print('Palette deleted successfully');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Color Picker FL',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white12,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _savePalette,
            icon: Icon(Icons.save, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: Row(
                  children: _currentPalette.colors.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Color color = entry.value;
                    // bool isLocked = _currentPalette.locked[idx];
                    return Expanded(
                      child: ColorCard(
                        color: color,
                        isLocked: _currentPalette.lockedColors[idx],
                        onTap: () => _lockColor(idx),
                        showHex: true,
                      ),
                    );
                  }).toList(),
                ),
              ),

              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generateNewPalette,
                        label: Text('Generate New Palette'),
                        icon: Icon(Icons.refresh),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_palettes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Palettes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // PaletteGrid(
                      //   palettes: _palettes,
                      //   onDelete: _deletePalette,
                      // ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
