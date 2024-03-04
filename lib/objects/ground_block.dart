import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GroundBlock extends SpriteComponent with HasGameReference<OceanGame> {
  final Vector2 gridPosition;
  double xOffset;

  final UniqueKey _blockKey = UniqueKey();
  final Vector2 velocity = Vector2.zero();

  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final groundImage = game.images.fromCache('ground.png');
    sprite = Sprite(groundImage);
    position = Vector2(
      (gridPosition.x * size.x + xOffset),
      game.size.y - gridPosition.y * size.y,
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  Vector2 screenSize = Vector2(0, 0);
  bool fisrtIteration = false;

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      position.x = position.x / screenSize.x * size.x;
      position.y = position.y / screenSize.y * size.y;
    } else if (fisrtIteration) {
      position.x = position.x / 1920 * size.x;
      //qposition.y = position.y / 1080 * size.y;
      debugPrint("First itération new size : $size");
      fisrtIteration = true;
    }

    scale = Vector2(size.x / 1920 * 0.8, size.y / 1080 * 0.8);
    screenSize = size;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed.x;
    velocity.y = game.objectSpeed.y;
    position += velocity * dt;
/*
    if (position.x < -size.x) {
      removeFromParent();
      if (gridPosition.x == 0) {
        /*game.loadGameSegments(
          Random().nextInt(segments.length),
          game.lastBlockXPosition,
        );*/
      }
    }
    if (gridPosition.x == 9) {
      if (game.lastBlockKey == _blockKey) {
        game.lastBlockXPosition = position.x + size.x - 10;
      }
    }*/

    if (position.x < -size.x) removeFromParent();
    if (position.x > screenSize.x + size.x) removeFromParent();

    if (position.y < -size.y) removeFromParent();
    if (position.y > screenSize.y + size.y) removeFromParent();
    if (game.health <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
