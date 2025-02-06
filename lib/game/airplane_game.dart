import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'player.dart';
import 'dart:math';
import 'enemy.dart';
import 'enemy_behavior.dart';
import 'bullet.dart';
import 'dart:async' as async;
import 'package:flame_audio/flame_audio.dart';

class AirplaneGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late Player player;
  final Set<LogicalKeyboardKey> keysPressed = {};
  final Random random = Random();
  int score = 0;
  int lives = 3;
  double survivalTime = 0;
  bool isGameOver = false;
  bool hasInteracted = false;

  SpriteComponent background1 = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  final double backgroundSpeed = 100;

  async.Timer? enemySpawnTimer;
  int enemySpawnInterval = 3000; // milliseconds

  // Callback for HUD
  Function? onGameStateChanged;

  @override
  Color backgroundColor() => const Color(0xFF87CEFF);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    loadBackground();
    player = Player();
    add(player);
    spawnEnemy();
    overlays.add('HUD');
    startEnemySpawnTimer();
    FlameAudio.bgm.initialize();
  }

  void loadBackground() async {
    final sprite = await loadSprite('mountains.png');

    background1.sprite = sprite;
    background1.size = Vector2(1216, 240);
    background1.position = Vector2(0, size.y - 240);
    background1.priority = 0;

    background2.sprite = sprite;
    background2.size = Vector2(1216, 240);
    background2.position = Vector2(background1.size.x - 1, size.y - 240);
    background2.priority = 0;

    add(background1);
    add(background2);
  }

  void updateBackground(double dt) {
    background1.x -= backgroundSpeed * dt;
    background2.x -= backgroundSpeed * dt;

    if (background1.x + background1.width < 0) {
      background1.x = background2.x + background2.width - 1;
    }

    if (background2.x + background2.width < 0) {
      background2.x = background1.x + background1.width - 1;
    }
  }

  void startMusic() {
    FlameAudio.bgm.initialize();
    if (!hasInteracted){
      hasInteracted = true;
      FlameAudio.bgm.play('background_music.mp3', volume: 0.3);
    }
  }

  void increaseScore() {
    score += 1;
    notifyGameStateChanged();
  }

  void decreaseLife() {
    lives -= 1;
    if (lives <= 0) {
      gameOver();
    }
    notifyGameStateChanged();
  }

  void notifyGameStateChanged() {
    if (onGameStateChanged != null) {
      onGameStateChanged!();
    }
  }

  void gameOver() {
    isGameOver = true;
    overlays.remove('HUD');
    overlays.add('GameOver');
    enemySpawnTimer?.cancel();
    pauseEngine();
  }

  void reset() {
    score = 0;
    lives = 3;
    survivalTime = 0;
    isGameOver = false;
    enemySpawnInterval = 3000;

    if (player.parent != null){
      player.removeFromParent();
    }

    removeWhere((component) => component is Enemy || component is Bullet);
    
    player = Player();
    add(player);

    spawnEnemy();
    enemySpawnTimer?.cancel();
    startEnemySpawnTimer();
    overlays.add('HUD');
    overlays.remove('GameOver');
    resumeEngine();
  }

  void startEnemySpawnTimer() {
    enemySpawnTimer?.cancel();

    enemySpawnTimer = async.Timer.periodic(
      Duration(milliseconds: enemySpawnInterval),
      (timer) {
        if (!isGameOver) {
          spawnEnemy();
          decreaseSpawnInterval();
        }
      },
    );
  }

  void decreaseSpawnInterval() {
    if (enemySpawnInterval > 750) {
      enemySpawnInterval -= 100;
    }
    
    startEnemySpawnTimer();
  }

  void spawnEnemy() {
    final Enemy enemy;

    if (random.nextBool()){
      enemy = Enemy(StraightMovement(), 200);
      enemy.position = Vector2(1350, random.nextDouble() * 600);
    }
    else{
      enemy = Enemy(ZigZagMovement(), 200);
      enemy.position = Vector2(1350, random.nextDouble() * 400);
    }

    add(enemy);
  }

  @override
  void update(double dt) {
    if (!isGameOver) {
      super.update(dt);
      survivalTime += dt;
      player.handleInput(keysPressed, dt);
      notifyGameStateChanged();
      updateBackground(dt);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    startMusic();
    this.keysPressed.clear();
    this.keysPressed.addAll(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    super.onRemove();
  }
}