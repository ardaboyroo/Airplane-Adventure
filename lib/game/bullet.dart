import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/painting.dart';
import 'airplane_game.dart';

class BulletTrail extends ParticleSystemComponent {
  BulletTrail(Vector2 position)
      : super(
          position: Vector2(position.x + 1, position.y + 16),
          particle: Particle.generate(
            count: 5,
            lifespan: 0.2,
            generator: (i) {
              return AcceleratedParticle(
                //acceleration: Vector2.random() * 200,
                speed: Vector2(
                  -100 + Random().nextDouble() * -50, // Moves left (-X direction)
                  (Random().nextDouble() - 0.5) * 200, // Slight vertical randomness
                ),
                child: CircleParticle(
                  radius: 2,
                  paint: Paint()..color = const Color(0xFFFFA500),
                  lifespan: 0.2,
                ),
              );
            },
          ),
        );
}

class Bullet extends SpriteComponent with HasGameRef<AirplaneGame>, CollisionCallbacks {
  static const double speed = 300;

  Bullet(Vector2 startPosition) {
    size = Vector2(50 , 25);
    position = startPosition;
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bullet.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;

    gameRef.add(BulletTrail(position.clone()));

    if (position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}