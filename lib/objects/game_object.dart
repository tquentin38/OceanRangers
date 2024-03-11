import 'package:flame/components.dart';

abstract class GameObject {
  late PreLoadedGameObject preLoadedGameObject;
  late bool activated = true;

  PreLoadedGameObject getPreLoadedGameObject() {
    return preLoadedGameObject;
  }

  Vector2 getPosition();
  void setPosition(Vector2 newPosition);
  void removeObject();
}

class PreLoadedGameObject {
  Vector2 futurPosition;
  GameObjectType type;
  double randomDouble;

  PreLoadedGameObject(this.futurPosition, this.type, this.randomDouble);

  updateFuturPosition(double ratioX, double ratioY) {
    futurPosition = Vector2(futurPosition.x * ratioX, futurPosition.y * ratioY);
  }
}

enum GameObjectType implements Comparable<GameObjectType> {
  trash(identifier: 0, name: "Trash"),
  fish(identifier: 1, name: "Fish"),
  enemy(identifier: 3, name: "Enemy"),
  ;

  const GameObjectType({
    required this.identifier,
    required this.name,
  });

  final int identifier;
  final String name;

  @override
  int compareTo(GameObjectType other) => identifier - other.identifier;
}
