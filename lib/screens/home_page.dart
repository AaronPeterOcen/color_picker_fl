import 'package:flutter/material.dart';
import '../models/color_palette.dart';
import '../widgets/color_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

/// State class for HomePage that manages the app's main functionality
/// including palette generation, color locking, and saved palettes management
class _HomePageState extends State<HomePage> {
  List<ColorPalette> _palettes = [];
  ColorPalette _currentPalette = ColorPalette.generateRandom();

  @override
  void initState() {
    super.initState();
    // Load any previously saved palettes when the app starts
    _loadSavedPalettes();
  }

  /// Loads saved palettes from storage (currently initializes empty list)
  /// In a production app, this would load from shared preferences or database
  void _loadSavedPalettes() {
    setState(() {
      _palettes =
          []; // Initialize with empty list - replace with actual data loading
    });
  }

  /// Generates a new random color palette and updates the UI
  /// This creates a completely new palette with all new colors
  void _generateNewPalette() {
    setState(() {
      _currentPalette = ColorPalette.generateRandom();
    });
  }

  /// Toggles the lock state of a color at the specified index
  /// Locked colors won't change when generating new palettes
  ///
  /// @param index: The position of the color in the palette to lock/unlock
  void _lockColor(int index) {
    setState(() {
      _currentPalette.lockedColors(index); // Toggle lock state
    });
  }

  /// Saves the current palette to the saved palettes list
  /// Creates a copy of the current palette to preserve its state
  /// Shows a confirmation snackbar when successful
  void _savePalette() {
    setState(() {
      // Add a copy of current palette to prevent reference issues
      _palettes.add(_currentPalette.copyWith());
    });
    // Show success message to user
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Palette saved!')));
  }

  /// Deletes a saved palette from the list at the specified index
  /// Includes safety checks to prevent index out of bounds errors
  ///
  /// @param index: The position of the palette to delete in the saved list
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
            // ========== CURRENT PALETTE DISPLAY SECTION ==========
            // Displays the main interactive color palette that user can work with
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 400, // Fixed height for the color palette display
                child: Row(
                  // Convert colors list to map entries to access both index and color value
                  // This allows us to know which color is at which position for locking
                  children: _currentPalette.colors.asMap().entries.map((entry) {
                    int index = entry.key;
                    Color color = entry.value;
                    return Expanded(
                      child: ColorCard(
                        color: color,
                        isLocked: _currentPalette
                            .lockedColor[index], // Current lock state
                        onTap: () => _lockColor(index),
                        showHex: true,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ========== GENERATE BUTTON SECTION ==========
            // Button to generate a new random color palette
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

            // ========== SAVED PALETTES SECTION ==========
            // Displays all previously saved color palettes
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

  /// Builds the list of saved palettes or shows empty state message
  ///
  /// @return Widget: Either a ListView of saved palettes or empty state message
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

    // Build ListView when there are saved palettes
    return ListView.builder(
      shrinkWrap: true, // Important: Allows ListView inside Column/ScrollView
      physics: NeverScrollableScrollPhysics(),
      itemCount: _palettes.length,
      itemBuilder: (context, index) {
        final palette = _palettes[index];
        return _buildPaletteListItem(palette, index);
      },
    );
  }

  /// Builds an individual list item for a saved color palette
  /// Shows the color palette and provides delete functionality
  ///
  /// @param palette: The ColorPalette object to display
  /// @param index: The position of this palette in the saved list (for deletion)
  /// @return Widget: A Card containing the palette preview and delete button
  Widget _buildPaletteListItem(ColorPalette palette, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
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
            // Shows palette identifier and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Palette identifier (e.g., "Palette 1", "Palette 2")
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
