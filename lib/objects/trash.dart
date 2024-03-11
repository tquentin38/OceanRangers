import 'dart:math';

import 'package:ocean_rangers/ocean_game.dart';
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
    int randomX = Random().nextInt(100);
    int randomY = Random().nextInt(100);
    random = Vector2(randomX / 100 * 0.2 + 0.9, randomY / 100 * 0.2 + 0.9);

    if (random.x < 0.90) {
      debugPrint(
          "x<0.9 : rnd ($randomX, $randomY) -> (${random.x},${random.y})");
    }
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
    angle = (Random().nextInt(359) + 1) * pi / 180;
  }

  Vector2 screenSize = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    /* if (size.x < 500 || size.y < 500) {
      debugPrint("size.x or y < 500 : (${size.x},${size.y})");
    }*/
    x = size.x;
    y = size.y;
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
    //debugPrint(
    //  "Trash onGameResize (${size.x},${size.y}) scale : (${scale.x.toStringAsFixed(3)}, ${scale.y.toStringAsFixed(3)})");
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
      deepMin: 0,
      deepPeak: 300,
      deepMax: 1500,
      size: 0.75,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "conserves.png",
      grant: [RessourceHolder(RessourcesTypes.iron, 3)]),
  bouteille(
      identifier: 1,
      name: "Bouteille",
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      size: 0.4,
      sizeInInventory: 1,
      pointNumber: 3,
      imageFile: "bouteille_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  couvert(
      identifier: 1,
      name: "Couvert",
      deepMin: 0,
      deepPeak: 60,
      deepMax: 250,
      size: 0.6,
      sizeInInventory: 1,
      pointNumber: 1,
      imageFile: "couvert_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  canette(
      identifier: 2,
      name: "Canette",
      deepMin: 0,
      deepPeak: 600,
      deepMax: 999,
      size: 0.4,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "canette_s.png",
      grant: [RessourceHolder(RessourcesTypes.iron, 3)]),
  goblet(
      identifier: 3,
      name: "Goblet",
      deepMin: 0,
      deepPeak: 300,
      deepMax: 1250,
      size: 0.5,
      sizeInInventory: 1,
      pointNumber: 2,
      imageFile: "gobelet_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  gourde(
      identifier: 4,
      name: "Gourde",
      deepMin: 0,
      deepPeak: 500,
      deepMax: 4000,
      size: 0.75,
      sizeInInventory: 1,
      pointNumber: 4,
      imageFile: "gourde_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 3)]),
  plasticBag(
      identifier: 5,
      name: "Plastic bag",
      deepMin: 0,
      deepPeak: 1000,
      deepMax: 5000,
      size: 1,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "sac_plastique_s.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  robot(
      identifier: 6,
      name: "Robot",
      deepMin: 0,
      deepPeak: 250,
      deepMax: 1000,
      size: 1,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "robot.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  ancre(
      identifier: 7,
      name: "Ancre",
      deepMin: 0,
      deepPeak: 800,
      deepMax: 1500,
      size: 1.5,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "ancre.png",
      grant: [RessourceHolder(RessourcesTypes.platic, 6)]),
  wood(
      identifier: 8,
      name: "Wood",
      deepMin: -50,
      deepPeak: 75,
      deepMax: 150,
      size: 1.2,
      sizeInInventory: 2,
      pointNumber: 6,
      imageFile: "wood.png",
      grant: [RessourceHolder(RessourcesTypes.wood, 10)]),
  ;

  const TrashType({
    required this.identifier,
    required this.name,
    required this.deepMin,
    required this.deepPeak,
    required this.deepMax,
    required this.size,
    required this.sizeInInventory,
    required this.pointNumber,
    required this.imageFile,
    required this.grant,
  });

  final int identifier;
  final String name;
  final int deepMin;
  final int deepPeak;
  final int deepMax;
  final double size;
  final int sizeInInventory;
  final int pointNumber;
  final String imageFile;
  final List<RessourceHolder> grant;

  @override
  int compareTo(TrashType other) => identifier - other.identifier;
}
