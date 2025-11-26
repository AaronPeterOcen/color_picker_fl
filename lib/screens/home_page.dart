import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            onPressed: () {},
            icon: Icon(Icons.save, color: Colors.black87),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Color Picker FL App!')),
    );
  }
}
