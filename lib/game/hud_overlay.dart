import 'package:flutter/material.dart';
import 'airplane_game.dart';

class HUD extends StatefulWidget {
  final AirplaneGame game;

  const HUD({required this.game, super.key});

  @override
  HUDState createState() => HUDState();
}

class HUDState extends State<HUD> {
  late AirplaneGame game;

  @override
  void initState() {
    super.initState();
    game = widget.game;
    game.onGameStateChanged = _updateHUD;
  }

  @override
  void dispose() {
    game.onGameStateChanged = null;
    super.dispose();
  }

  void _updateHUD() {
    // Rebuild HUD
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time: ${game.survivalTime.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Score: ${game.score}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Lives: ${game.lives}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}