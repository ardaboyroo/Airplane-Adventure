import 'package:air_adventure/game/game_over_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/airplane_game.dart';
import 'game/hud_overlay.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = AirplaneGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameOver': (context, game) => GameOverOverlay(game: game as AirplaneGame),
            'HUD': (context, game) => HUD(game: game as AirplaneGame)
          },
        ),
      ),
    );
  }
}