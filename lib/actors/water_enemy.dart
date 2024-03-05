import 'package:ocean_rangers/objects/game_object.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class WaterEnemy extends SpriteAnimationComponent
    with HasGameReference<OceanGame>
    implements GameObject {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();
  final WaterEnemyType waterEnemyType;

  WaterEnemy(
      {required this.gridPosition,
      required this.preLoadedGameObject,
      required this.waterEnemyType})
      : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);
  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      //game.images.fromCache('light_fishs.png'),
      game.images.fromCache(waterEnemyType.imageFile),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(173, 149),
        stepTime: 0.70,
      ),
    );
    position = gridPosition;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  Vector2 screenSize = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      position.x = position.x / screenSize.x * size.x * waterEnemyType.size;
      position.y = position.y / screenSize.y * size.y * waterEnemyType.size;
      screenSize = size;
    }
    scale = Vector2(size.x / 1920 * 0.8, size.y / 1080 * 0.8);
    super.onGameResize(size);
  }

  int maxDelta = 150;
  int currentDelta = 0;
  bool positive = true;

  @override
  void update(double dt) {
    if (positive) {
      currentDelta++;
      if (currentDelta > maxDelta) {
        currentDelta = maxDelta;
        positive = false;

        flipHorizontallyAroundCenter();
      }
    } else {
      currentDelta--;
      if (currentDelta < -1 * maxDelta) {
        currentDelta = -maxDelta;
        positive = true;
        flipHorizontallyAroundCenter();
      }
    }
    /*velocity.x = game.objectSpeed.x;
    velocity.y = game.objectSpeed.y;
    position += velocity * dt;

    if (position.x < -size.x) removeFromParent();
    if (position.x > screenSize.x + size.x) removeFromParent();

    if (position.y < -size.y) removeFromParent();
    if (position.y > screenSize.y + size.y) removeFromParent();

    if (position.x < -size.x || game.health <= 0) {
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
    position.add(Vector2(150 * currentDelta / maxDelta, 0));
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

enum WaterEnemyType implements Comparable<WaterEnemyType> {
  fish_15(
      identifier: 0,
      name: "fish_15",
      deepMin: 500,
      deepPeak: 1000,
      deepMax: 3000,
      size: 1.2,
      imageFile: "fish_15.png"),
  piranha(
      identifier: 1,
      name: "piranha",
      deepMin: 50,
      deepPeak: 500,
      deepMax: 750,
      size: 1.1,
      imageFile: "piranha.png"),
  ;

  const WaterEnemyType({
    required this.identifier,
    required this.name,
    required this.deepMin,
    required this.deepPeak,
    required this.deepMax,
    required this.size,
    required this.imageFile,
  });

  final int identifier;
  final String name;
  final int deepMin;
  final int deepPeak;
  final int deepMax;
  final double size;
  final String imageFile;

  @override
  int compareTo(WaterEnemyType other) => identifier - other.identifier;
}
