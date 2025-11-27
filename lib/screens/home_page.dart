import 'package:flutter/material.dart';
import '../models/color_palette.dart';
import '../widgets/color_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
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
    // Start with empty list
    setState(() {
      _palettes = [];
    });
  }

  void _generateNewPalette() {
    setState(() {
      _currentPalette = ColorPalette.generateRandom();
    });
  }

  void _lockColor(int index) {
    setState(() {
      _currentPalette.lockedColors(index);
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

  void _deletePalette(int index) {
    if (index < 0 || index >= _palettes.length) return;

    setState(() {
      _palettes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Color Palette Generator',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black12,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.black87),
            onPressed: _savePalette,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current palette
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                child: Row(
                  children: _currentPalette.colors.asMap().entries.map((entry) {
                    int index = entry.key;
                    Color color = entry.value;
                    return Expanded(
                      child: ColorCard(
                        color: color,
                        isLocked: _currentPalette.lockedColor[index],
                        onTap: () => _lockColor(index),
                        showHex: true,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Generate button
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.refresh),
                      label: Text('Generate New Palette'),
                      onPressed: _generateNewPalette,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Palettes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildSavedPalettesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPalettesList() {
    if (_palettes.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        child: Text(
          'No saved palettes yet.\nGenerate and save some palettes!',
          style: TextStyle(color: Colors.blueGrey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _palettes.length,
      itemBuilder: (context, index) {
        final palette = _palettes[index];
        return _buildPaletteListItem(palette, index);
      },
    );
  }

  Widget _buildPaletteListItem(ColorPalette palette, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Color bars
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: palette.colors.map((color) {
                  return Expanded(child: Container(color: color));
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
            // Palette info and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Palette ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.deepOrange),
                  onPressed: () => _deletePalette(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
