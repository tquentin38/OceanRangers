import 'dart:math';

import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_object.dart';

class Fish extends SpriteComponent
    with HasGameReference<OceanGame>
    implements GameObject {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();
  final FishType fishType;
  late Vector2 random;
  Vector2 speed = Vector2(0, 0);
  Vector2 currentDelta = Vector2(0, 0);
  Vector2 maxDelta = Vector2(0, 0);
  Vector2 sensDelta = Vector2(1, 1);
  Fish(
      {required this.gridPosition,
      required this.preLoadedGameObject,
      required this.fishType})
      : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    random = Vector2(Random().nextInt(100) / 100 * 0.4 + 0.8,
        Random().nextInt(100) / 100 * 0.4 + 0.8);
    final starImage = game.images.fromCache(fishType.imageFile);
    sprite = Sprite(starImage,
        srcSize: Vector2(fishType.srcSizeX, fishType.srcSizeY));

    position = gridPosition;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    initMovement();
  }

  Vector2 screenSize = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      //position.x = position.x / screenSize.x * size.x;
      //position.y = position.y / screenSize.y * size.y;
    }
    //angle = Random().nextInt(360) * pi / 180;

    double x = size.x;
    double y = size.y;
    if (x > 1920) {
      x = 1920;
    }
    if (y > 1080) {
      y = 1080;
    }
    size = Vector2(x, y);
    scale = Vector2(size.x / 1920 * fishType.sizex * 0.5 * random.x,
        size.y / 1080 * fishType.sizey * 0.5 * random.y);
    screenSize = size;
    super.onGameResize(size);
  }

  void initMovement() {
    //random x and y e [0;2.5]
    speed = Vector2(Random().nextDouble() * 2.5, Random().nextDouble() * 2.5);
    currentDelta = Vector2(0, 0);
    //random max delta e [0; 150]
    maxDelta = Vector2(
        Random().nextDouble() * 150 + 30, Random().nextDouble() * 150 + 30);
    sensDelta = Vector2(
        Random().nextInt(1) == 0 ? -1 : 1, Random().nextInt(1) == 0 ? -1 : 1);
  }

  @override
  void update(double dt) {
    if (currentDelta.y > 250) {
      debugPrint(
          "currentDelta.y > 250 !! currentDelta.y : ${currentDelta.y}  maxDelta.y : ${maxDelta.y} & speed.y: ${speed.y}");
    }
    if (sensDelta.x == 1) {
      currentDelta.x += speed.x;
      if (currentDelta.x > maxDelta.x) {
        currentDelta.x = maxDelta.x;
        sensDelta.x = -1;
        flipHorizontallyAroundCenter();
      }
    } else {
      currentDelta.x -= speed.x;
      if (currentDelta.x < -1 * maxDelta.x) {
        currentDelta.x = -1 * maxDelta.x;
        sensDelta.x = 1;
        flipHorizontallyAroundCenter();
      }
    }
    if (sensDelta.y == 1) {
      currentDelta.y += speed.y;
      if (currentDelta.y > maxDelta.y) {
        currentDelta.y = maxDelta.y;
        sensDelta.y = -1;
        //flipHorizontallyAroundCenter();
      }
    } else {
      currentDelta.y -= speed.y;
      if (currentDelta.y < -1 * maxDelta.y) {
        currentDelta.y = -1 * maxDelta.y;
        sensDelta.y = 1;
        //flipHorizontallyAroundCenter();
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
    position.add(Vector2(currentDelta.x, currentDelta.y));
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

enum FishType implements Comparable<FishType> {
  fish_1(
      identifier: 0,
      name: "fish_1",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_1.png",
      srcSizeX: 111,
      srcSizeY: 115),
  fish_2(
      identifier: 1,
      name: "fish_2",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_2.png",
      srcSizeX: 125,
      srcSizeY: 71),
  fish_3(
      identifier: 2,
      name: "fish_3",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_3.png",
      srcSizeX: 144,
      srcSizeY: 84),
  fish_4(
      identifier: 3,
      name: "fish_4",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_4.png",
      srcSizeX: 120,
      srcSizeY: 56),
  fish_5(
      identifier: 4,
      name: "fish_5",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_5.png",
      srcSizeX: 113,
      srcSizeY: 96),
  fish_6(
      identifier: 5,
      name: "fish_6",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_6.png",
      srcSizeX: 186,
      srcSizeY: 78),
  fish_7(
      identifier: 6,
      name: "fish_7",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_7.png",
      srcSizeX: 201,
      srcSizeY: 81),
  fish_8(
      identifier: 7,
      name: "fish_8",
      sizex: 1.5,
      sizey: 1.5,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_8.png",
      srcSizeX: 83,
      srcSizeY: 79),
  fish_9(
      identifier: 8,
      name: "fish_9",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_9.png",
      srcSizeX: 1378,
      srcSizeY: 587),
  fish_10(
      identifier: 9,
      name: "fish_10",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_10.png",
      srcSizeX: 1214,
      srcSizeY: 332),
  fish_11(
      identifier: 10,
      name: "fish_11",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_11.png",
      srcSizeX: 1097,
      srcSizeY: 420),
  fish_12(
      identifier: 11,
      name: "fish_12",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_12.png",
      srcSizeX: 808,
      srcSizeY: 370),
  fish_13(
      identifier: 12,
      name: "fish_13",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_13.png",
      srcSizeX: 1231,
      srcSizeY: 322),
  fish_14(
      identifier: 13,
      name: "fish_14",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_14.png",
      srcSizeX: 655,
      srcSizeY: 185),
  /*fish_15(
      identifier: 14,
      name: "fish_15",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepMax: 150,
      imageFile: "fish_15.png"),*/
  fish_16(
      identifier: 15,
      name: "fish_16",
      sizex: 1,
      sizey: 1,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "fish_16.png",
      srcSizeX: 116,
      srcSizeY: 99),
  bancPoisson(
      identifier: 16,
      name: "banc_poisson",
      sizex: 3.5,
      sizey: 3.5,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "banc_poisson.png",
      srcSizeX: 468,
      srcSizeY: 188),
  blueWhale(
      identifier: 17,
      name: "Blue_Whale",
      sizex: 5,
      sizey: 5,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "Blue_Whale.png",
      srcSizeX: 227,
      srcSizeY: 112),
  dauphin(
      identifier: 18,
      name: "dauphin",
      sizex: 4,
      sizey: 4,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "dauphin.png",
      srcSizeX: 229,
      srcSizeY: 97),
  mantaRay(
      identifier: 19,
      name: "Manta_Ray",
      sizex: 3,
      sizey: 3,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "Manta_Ray.png",
      srcSizeX: 162,
      srcSizeY: 174),
  tortue(
      identifier: 20,
      name: "tortue",
      sizex: 3,
      sizey: 3,
      deepMin: 0,
      deepPeak: 75,
      deepMax: 150,
      imageFile: "tortue.png",
      srcSizeX: 335,
      srcSizeY: 159),
  ;

  const FishType({
    required this.identifier,
    required this.name,
    required this.sizex,
    required this.sizey,
    required this.deepMin,
    required this.deepPeak,
    required this.deepMax,
    required this.imageFile,
    required this.srcSizeX,
    required this.srcSizeY,
  });

  final int identifier;
  final String name;
  final double sizex;
  final double sizey;
  final int deepMin;
  final int deepPeak;
  final int deepMax;
  final String imageFile;
  final double srcSizeX;
  final double srcSizeY;

  @override
  int compareTo(FishType other) => identifier - other.identifier;
}
