import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game_object.dart';

class PlatformBlock extends SpriteComponent
    with HasGameReference<OceanGame>
    implements GameObject {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  PlatformBlock({required this.gridPosition, required this.preLoadedGameObject})
      : super(size: Vector2.all(128), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final platformImage = game.images.fromCache('banc_s.png');
    sprite = Sprite(platformImage);
    position = gridPosition;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  Vector2 screenSize = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      position.x = position.x / screenSize.x * size.x;
      position.y = position.y / screenSize.y * size.y;
    }

    //scale = Vector2(size.x / 1920, size.y / 1080);
    screenSize = size;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    /*velocity.x = game.objectSpeed.x;
    velocity.y = game.objectSpeed.y;
    position += velocity * dt;*/

    //if (position.x < -size.x) removeFromParent();
    //if (position.x > screenSize.x + size.x) removeFromParent();

    //if (position.y < -size.y) removeFromParent();
    //if (position.y > screenSize.y + size.y) removeFromParent();

    /*if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }*/

    super.update(dt);
  }

  @override
  Vector2 getPosition() {
    return position;
  }

  @override
  void removeObject() {
    removeFromParent();
  }

  @override
  void setPosition(Vector2 newPosition) {
    position = newPosition;
  }

  @override
  PreLoadedGameObject preLoadedGameObject;

  @override
  PreLoadedGameObject getPreLoadedGameObject() {
    return preLoadedGameObject;
  }

  @override
  bool activated = true;
}
