import 'enemy.dart';
import 'dart:math';

abstract class EnemyBehavior {
  void move(Enemy enemy, double dt);
}

class StraightMovement implements EnemyBehavior {
  @override
  void move(Enemy enemy, double dt) {
    enemy.position.x -= enemy.speed * dt;
  }
}

class ZigZagMovement implements EnemyBehavior {
  double direction = 1;
  double time = 0;

  @override
  void move(Enemy enemy, double dt) {
    time += dt;
    enemy.position.x -= enemy.speed * dt;
    enemy.position.y += sin(time * 3) * 400 * dt;
  }
}