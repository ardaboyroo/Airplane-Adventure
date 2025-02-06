import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'airplane_game.dart';
import 'enemy_behavior.dart';
import 'bullet.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<AirplaneGame>, CollisionCallbacks {
  final EnemyBehavior behavior;
  double speed;

  Enemy(this.behavior, this.speed) {
    size = Vector2(50, 50);
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final spriteSheet = await Flame.images.load('enemy_duck.png');

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 3, // Frames
        stepTime: 0.3,
        textureSize: Vector2(30, 25),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      removeFromParent();
      FlameAudio.play('quack.mp3');
      other.removeFromParent();
      gameRef.increaseScore();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    super.update(dt);
    behavior.move(this, dt);
  }
}