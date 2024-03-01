import 'dart:math';

import 'package:challenge2024/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../core/ressources/ressource.dart';
import 'game_object.dart';

class Trash extends SpriteComponent
    with HasGameReference<OceanGame>
    implements GameObject {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();
  late Vector2 random;
  final TrashType trashType;
  Trash(
      {required this.gridPosition,
      required this.preLoadedGameObject,
      required this.trashType})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    random = Vector2(Random().nextInt(100) / 100 * 0.2 + 0.9,
        Random().nextInt(100) / 100 * 0.2 + 0.9);
    final starImage = game.images.fromCache(trashType.imageFile);
    sprite = Sprite(starImage);

    position = gridPosition;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(
      SizeEffect.by(
        Vector2(-5, -5),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
    setRandomAngle();
  }

  void setRandomAngle() {
    List<double> anglesPossible = [0, 45, 90, 135, 180, 225, 270, 315, 360];
    angle =
        anglesPossible[Random().nextInt(anglesPossible.length - 1)] * pi / 180;
  }

  Vector2 screenSize = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (x > 1920) {
      x = 1920;
    }
    if (y > 1080) {
      y = 1080;
    }
    size = Vector2(x, y);
    if (screenSize.x != 0 && size != screenSize) {
      position.x = position.x / screenSize.x * size.x * random.x;
      position.y = position.y / screenSize.y * size.y * random.y;
    }

    scale =
        Vector2(size.x / 1920 * trashType.size, size.y / 1080 * trashType.size);
    screenSize = size;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    /*velocity.x = game.objectSpeed.x;
    velocity.y = game.objectSpeed.y;
    position += velocity * dt;*/

    /*if (position.x < -size.x) removeFromParent();
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
  }

  @override
  PreLoadedGameObject getPreLoadedGameObject() {
    return preLoadedGameObject;
  }

  @override
  PreLoadedGameObject preLoadedGameObject;

  @override
  bool activated = true;
}

enum TrashType implements Comparable<TrashType> {
  conserves(
      identifier: 0,
      name: "Conserve",
      size: 0.75,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "conserves.png",
      grant: [RessourceHolder(RessourcesTypes.iron, 3)]),
  bouteille(
      identifier: 1,
      name: "Bouteille",
      size: 0.4,
      sizeInInventory: 1,
      pointNumber: 3,
      imageFile: "bouteille_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  couvert(
      identifier: 1,
      name: "Couvert",
      size: 0.6,
      sizeInInventory: 1,
      pointNumber: 1,
      imageFile: "couvert_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  canette(
      identifier: 2,
      name: "Canette",
      size: 0.4,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "canette_s.png",
      grant: [RessourceHolder(RessourcesTypes.iron, 3)]),
  goblet(
      identifier: 3,
      name: "Goblet",
      size: 0.5,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "gobelet_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  gourde(
      identifier: 4,
      name: "Gourde",
      size: 0.75,
      sizeInInventory: 1,
      pointNumber: 4,
      imageFile: "gourde_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  plasticBag(
      identifier: 5,
      name: "Plastic bag",
      size: 1,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "sac_plastique_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  robot(
      identifier: 6,
      name: "Robot",
      size: 1,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "robot.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  ancre(
      identifier: 7,
      name: "Ancre",
      size: 3,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "ancre.jpg",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  ;

  const TrashType({
    required this.identifier,
    required this.name,
    required this.size,
    required this.sizeInInventory,
    required this.pointNumber,
    required this.imageFile,
    required this.grant,
  });

  final int identifier;
  final String name;
  final double size;
  final int sizeInInventory;
  final int pointNumber;
  final String imageFile;
  final List<RessourceHolder> grant;

  @override
  int compareTo(TrashType other) => identifier - other.identifier;
}
