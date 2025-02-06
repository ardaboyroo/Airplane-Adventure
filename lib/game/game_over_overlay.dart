import 'package:flutter/material.dart';
import '../game/airplane_game.dart';

class GameOverOverlay extends StatelessWidget {
  final AirplaneGame game;

  const GameOverOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          Text('Survival Time: ${game.survivalTime.toStringAsFixed(2)} seconds'),
          Text('Score: ${game.score}'),
          ElevatedButton(
            onPressed: () {
              game.reset();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}