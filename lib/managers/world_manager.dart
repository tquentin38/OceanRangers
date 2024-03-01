import 'dart:math';

import 'package:challenge2024/managers/chunk.dart';
import 'package:challenge2024/ocean_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Block {
  final Vector2 gridPosition;
  final Type blockType;
  Block(this.gridPosition, this.blockType);
}

class WorldManager {
  final World world;
  final OceanGame game;
  Vector2 position = Vector2(0, 0);
  Vector2 screenSize = Vector2(1920, 1080);
  bool hasStarted = false;
  bool isInit = false;
  int seed = 505412;
  List<Chunk> loadedChunk = [];

  WorldManager(this.world, this.game) {
    seed = Random().nextInt(999999) + 50000;
  }

  void init() {
    //Chunk newChunk = Chunk(Vector2(0, 0), this, seed, game);
    //newChunk.preLoadChunck();
    //loadedChunk.add(newChunk);
    updateChunk(Vector2(0, 0));
  }

  Vector2 getRelativePositionToZeroZero() {
    return Vector2(
        screenSize.x / 2 + position.x, screenSize.y / 2 - position.y);
  }

  Vector2 getRelativePositionToZeroOfChunck() {
    Vector2 girdPos = getChunck();
    return Vector2(
        screenSize.x / 2 + position.x - ((0.5 + girdPos.x) * screenSize.x),
        screenSize.y / 2 - position.y - ((0.5 + girdPos.y) * screenSize.y));
  }

  Vector2 translate(Vector2 chunckPosition, Vector2 positionPercent) {
    /*Vector2 translated = Vector2(
        (chunckPosition.x + 0.5 + positionPercent.x) * screenSize.x,
        (chunckPosition.y + 0.5 + positionPercent.y) * screenSize.y);
*/
    Vector2 translated = Vector2((positionPercent.x + 0.5) * screenSize.x,
        (positionPercent.y + 0.5) * screenSize.y);
    if (chunckPosition.y == 0) {
      translated.y += 100;
    }
    return translated;
  }

  void onGameResize(Vector2 size) {
    position.x *= screenSize.x / size.x;
    position.y *= screenSize.y / size.y;
    debugPrint("WorldManager - onGameResize $size");
    screenSize = size;
    if (!isInit) {
      //position = size / 2;
      init();
      isInit = true;
    } else {
      updateAllChunck();
    }
  }

  void setupStart() {
    //world.add(Star(gridPosition: Vector2(1, 1), xOffset: 0));
  }

  void resetPlayerGoBack() {
    hasStarted = false;
  }

  double getDeep() {
    return (position.y / screenSize.y * 20).abs();
  }

  Vector2 getPosition() {
    return position;
  }

  Vector2 getPositionInMeter() {
    double realX = position.x / screenSize.x * 20;
    double realY = position.y / screenSize.y * 20;
    return Vector2(realX, realY.abs());
  }

  Vector2 getChunck() {
    Vector2 pos = getPositionInMeter();
    return Vector2((pos.x - pos.x % 20) / 20, ((pos.y - pos.y % 20) / 20));
  }

  bool isOnScreen(Vector2 positionToCheck) {
    Vector2 pos = getRelativePositionToZeroZero();
    double deltaX = screenSize.x / 2 * 1.5;
    if (positionToCheck.x < pos.x - deltaX) {
      return false;
    }
    if (positionToCheck.x > pos.x + deltaX) {
      return false;
    }
    double deltaY = screenSize.y / 2 * 1.5;
    if (positionToCheck.y < pos.y - deltaY) {
      return false;
    }
    if (positionToCheck.y > pos.y + deltaY) {
      return false;
    }
    return true;
  }

  bool isPlayerWantToGoBack() {
    return (hasStarted && getDeep() < 0.5);
  }

  void updateAllChunck() {
    for (Chunk chunk in loadedChunk) {
      chunk.update(Vector2(0, 0));
    }
  }

  Chunk? isChunkLoaded(Vector2 chunkPositionToCompare) {
    for (Chunk chunk in loadedChunk) {
      if (chunk.chunkPosition == chunkPositionToCompare) {
        return chunk;
      }
    }
    return null;
  }

  void updateChunk(Vector2 objectSpeed) {
    Vector2 current = getChunck();
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        Vector2 chunkPosition = current.clone();
        chunkPosition.x += i;
        chunkPosition.y += j;
        if (chunkPosition.y >= 0) {
          //debugPrint("Check chunk $chunkPosition");
          Chunk? current = isChunkLoaded(chunkPosition);
          if (current == null) {
            Chunk newChunk = Chunk(chunkPosition, this, seed, game);
            newChunk.preLoadChunck();
            loadedChunk.add(newChunk);
          } else {
            current.update(objectSpeed);
          }
        }
      }
    }
  }

  void update(Vector2 objectSpeed) {
    if (game.onPause) return;
    //TODO REMOVE THIS
    position.x -= objectSpeed.x * 2;
    position.y += objectSpeed.y;
    //Go to the right
    if (objectSpeed.x > 0) {}
    //Go to the left
    if (objectSpeed.x < 0) {}
    //Go to the top
    if (objectSpeed.y < 0) {}
    //Go to the bottom
    if (objectSpeed.y > 0) {}

    updateChunk(objectSpeed);

    if (!hasStarted) {
      if (getDeep() > 1) {
        hasStarted = true;
      }
    }

    //assert(position.y <= 0, "World position y going > 0 (${position.y}) !!!!");
    // debugPrint(
    //   " World deep ${getDeep()} - Position : $position - speed $objectSpeed - ");
  }
}
