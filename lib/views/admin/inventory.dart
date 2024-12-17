import 'package:flutter/material.dart';
import 'dart:async';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late double progress; // Current progress value
  Timer? _timer;
  final int durationInSeconds=19; // Total time for the timer

  @override
  void initState() {
    super.initState();
    progress = 1.0; // Start with full progress
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress -= 1 / (durationInSeconds * 10); // Decrease progress
        if (progress <= 0) {
          progress = 0;
          _timer?.cancel(); // Stop the timer when progress reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linear Progress Timer'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Time Remaining',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress, // Bind progress to the LinearProgressIndicator
              minHeight: 20, // Set the height of the progress bar
              color: Colors.red, // Progress bar color
              backgroundColor: Colors.grey[300], // Background color
            ),
            const SizedBox(height: 20),
            Text(
              '${(progress * durationInSeconds).toInt()} seconds remaining',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),

    );
  }
}





