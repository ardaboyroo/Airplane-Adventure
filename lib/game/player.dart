import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'airplane_game.dart';
import 'bullet.dart';
import 'enemy.dart';

class Player extends SpriteComponent with HasGameRef<AirplaneGame>, CollisionCallbacks {
  static const double speed = 400.0;
  static const double bulletCooldown = 0.5;
  double lastShot = 0;

  Player() {
    size = Vector2(117, 41);
    position = Vector2(100, 300);
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    priority = 1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    lastShot += dt;
  }

  void handleInput(Set<LogicalKeyboardKey> keysPressed, double dt) {
    // Movement
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      position.y -= speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      position.y += speed * dt;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space) && lastShot >= bulletCooldown) {
      shoot();
      lastShot = 0;
    }
  }

  void shoot() {
    final bullet = Bullet(position.clone() + Vector2(size.x, size.y / 2));
    FlameAudio.play('shoot.wav');
    gameRef.add(bullet);
  }

  void damageEffect() {
    add(
    SequenceEffect([
      OpacityEffect.to(0,   EffectController(duration: 0.1)),
      OpacityEffect.to(1.0, EffectController(duration: 0.1)),
    ], repeatCount: 3),
    );
    
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(151, 255, 0, 0)));

    Future.delayed(const Duration(milliseconds: 600), () {
      decorator.removeLast();
    });
    
    //add(ColorEffect(Color.fromARGB(255, 255, 0, 0),  EffectController(duration: 0.6), opacityFrom: 0.3, opacityTo: 0.9));
    /**
    // Apply red tint effect
    final redEffect = ColorEffect(
      const Color(0xFFFF0000), // Red tint
      EffectController(duration: 0.6), // Duration matches blink cycle
      opacityFrom: 0.6,
      opacityTo: 0.6,
    );

    add(redEffect);

    // Reset color
    Future.delayed(const Duration(milliseconds: 600), () {
      add(ColorEffect(
        const Color(0xFFFFFFFF), // Reset to white (original color)
        EffectController(duration: 0.1),
        opacityFrom: 0.0, // Full opacity
        opacityTo: 0.0,
      ));
    });
    */
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      gameRef.decreaseLife();
      other.removeFromParent();
      FlameAudio.play('damage.wav');
      damageEffect();
    }
    super.onCollision(intersectionPoints, other);
  }
}