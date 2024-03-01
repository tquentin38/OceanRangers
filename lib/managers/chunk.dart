import 'dart:math';

import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/managers/world_manager.dart';
import 'package:ocean_rangers/objects/fish.dart';
import 'package:ocean_rangers/objects/game_object.dart';
import 'package:ocean_rangers/objects/trash.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Chunk {
  Vector2 chunkPosition;
  Vector2 chunkPositionToZero = Vector2(0, 0);
  int mainSeed;
  WorldManager worldManager;
  OceanGame game;
  int currentSeed = 0;
  late Random random;
  List<int> randomSuite = [];
  List<GameObject> loadedBlocks = [];
  List<PreLoadedGameObject> preLoadedGameObjects = [];

  Chunk(this.chunkPosition, this.worldManager, this.mainSeed, this.game) {
    initSeed();
  }

  void initSeed() {
    currentSeed =
        mainSeed + (chunkPosition.x.toInt() + chunkPosition.y.toInt() * 50);
    random = Random(currentSeed);
    debugPrint("Seed : $currentSeed - Pos : $chunkPosition");
    generateRandom();
  }

  void generateRandom() {
    for (int i = 0; i < 1000; i++) {
      randomSuite.add(random.nextInt(100));
    }
  }

  void update(Vector2 objectSpeed) {
    chunkPositionToZero.x = chunkPosition.x * worldManager.screenSize.x;
    chunkPositionToZero.y = chunkPosition.y * worldManager.screenSize.y;
    List<GameObject> toRemove = [];
    for (GameObject gameObject in loadedBlocks) {
      if (gameObject.activated) {
        if (worldManager.isOnScreen(
            gameObject.preLoadedGameObject.futurPosition +
                chunkPositionToZero)) {
          Vector2 delta = Vector2(0, 0);
          Vector2 currentChunk = worldManager.getChunck();
          delta.x =
              (chunkPosition.x - currentChunk.x) * worldManager.screenSize.x -
                  worldManager.getRelativePositionToZeroOfChunck().x;
          delta.y =
              (chunkPosition.y - currentChunk.y) * worldManager.screenSize.y -
                  worldManager.getRelativePositionToZeroOfChunck().y;
          Vector2 newPos = gameObject.preLoadedGameObject.futurPosition + delta;
          gameObject.setPosition(newPos);
        } else {
          gameObject.removeObject();
          preLoadedGameObjects.add(gameObject.getPreLoadedGameObject());
          toRemove.add(gameObject);
        }
      } else {
        gameObject.removeObject();
        toRemove.add(gameObject);
      }
    }
    for (GameObject removable in toRemove) {
      loadedBlocks.remove(removable);
    }
    checkForGenerate();
  }

  void checkForGenerate() {
    List<PreLoadedGameObject> toRemove = [];
    for (PreLoadedGameObject preLoadedGameObject in preLoadedGameObjects) {
      if (worldManager.isOnScreen(
          preLoadedGameObject.futurPosition + chunkPositionToZero)) {
        Vector2 delta = Vector2(0, 0);
        Vector2 currentChunk = worldManager.getChunck();
        delta.x =
            (currentChunk.x - chunkPosition.x) * worldManager.screenSize.x -
                worldManager.getRelativePositionToZeroOfChunck().x;
        delta.y =
            (currentChunk.y - chunkPosition.y) * worldManager.screenSize.y -
                worldManager.getRelativePositionToZeroOfChunck().y;
        switch (preLoadedGameObject.type) {
          case GameObjectType.trash:
            Trash star = Trash(
                gridPosition: delta + preLoadedGameObject.futurPosition,
                preLoadedGameObject: preLoadedGameObject,
                trashType: TrashType.values[(preLoadedGameObject.randomInt /
                        100 *
                        (TrashType.values.length - 1))
                    .round()]);
            game.add(star);
            loadedBlocks.add(star);
            debugPrint("added  Star ${preLoadedGameObject.futurPosition}");
            toRemove.add(preLoadedGameObject);
            break;
          case GameObjectType.fish:
            Fish plateforme = Fish(
                gridPosition: delta + preLoadedGameObject.futurPosition,
                preLoadedGameObject: preLoadedGameObject,
                fishType: FishType.values[(preLoadedGameObject.randomInt /
                        100 *
                        (FishType.values.length - 1))
                    .round()]);
            debugPrint(
                "added  PlatformBlock ${preLoadedGameObject.futurPosition}");
            game.add(plateforme);
            loadedBlocks.add(plateforme);
            toRemove.add(preLoadedGameObject);
            break;
          case GameObjectType.enemy:
            WaterEnemy plateforme = WaterEnemy(
                gridPosition: delta + preLoadedGameObject.futurPosition,
                preLoadedGameObject: preLoadedGameObject,
                waterEnemyType: WaterEnemyType.values[
                    (preLoadedGameObject.randomInt /
                            100 *
                            (WaterEnemyType.values.length - 1))
                        .round()]);
            debugPrint(
                "added  WaterEnemy ${preLoadedGameObject.futurPosition}");
            game.add(plateforme);
            loadedBlocks.add(plateforme as GameObject);
            toRemove.add(preLoadedGameObject);
            break;
          default:
            debugPrint("Default object type CALLED !!!!!!");
            break;
        }
      }
    }
    for (PreLoadedGameObject removable in toRemove) {
      preLoadedGameObjects.remove(removable);
    }
    //debugPrint("preLoadedGameObjects len : ${preLoadedGameObjects.length}");
  }

  void preLoadChunck() {
    //generate number for the process
    int bancRand = randomSuite[0];

    //generate number of fish banc type 1 - moy 10 in level 0m, 0 in level 100m

    preGenerateFish(10 + (bancRand / 100 * 10).round());

    preGenerateTrash(05 + (randomSuite[1] / 100 * 2).round());

    preGenerateEnemy(5);
    //randomSuite.clear();
  }

  void preGenerateTrash(int nb) {
    for (int i = 0; i < nb; i++) {
      Vector2 position = worldManager.translate(
          chunkPosition,
          Vector2(randomSuite[700 + 2 * i] / 100,
              randomSuite[700 + 2 * i + 1] / 100));
      //debugPrint("generateTrash($i) in $position");
      //debugPrint("preLoadedGameObjects trash $position");
      preLoadedGameObjects.add(PreLoadedGameObject(
          position, GameObjectType.trash, randomSuite[600 + 2 * i]));
    }
  }

  void preGenerateEnemy(int nb) {
    for (int i = 0; i < nb; i++) {
      Vector2 position = worldManager.translate(
          chunkPosition,
          Vector2(randomSuite[600 + 2 * i] / 100,
              randomSuite[600 + 2 * i + 1] / 100));
      //debugPrint("generateTrash($i) in $position");
      //debugPrint("preLoadedGameObjects ENEMY $position");
      preLoadedGameObjects.add(PreLoadedGameObject(
          position, GameObjectType.enemy, randomSuite[600 + 2 * i]));
    }
  }

  void preGenerateFish(int nb) {
    for (int i = 0; i < nb; i++) {
      Vector2 position = worldManager.translate(
          chunkPosition,
          Vector2(randomSuite[500 + 2 * i] / 100,
              randomSuite[500 + 2 * i + 1] / 100));
      //debugPrint("preLoadedGameObjects fish $position");
      preLoadedGameObjects.add(PreLoadedGameObject(
          position, GameObjectType.fish, randomSuite[500 + 2 * i]));
    }
  }

  /*@Deprecated("Now use pregenerate and load on the fly")
  void generateChunk() {
    //generate number for the process
    int bancRand = randomSuite[0];

    //generate number of fish banc type 1 - moy 10 in level 0m, 0 in level 100m
    if (chunkPosition.y < 5) {
      generateBanc(
          5 + (bancRand / 100 * (10 * (5 - chunkPosition.y) / 5)).round());
    }

    generateTrash(5 + (randomSuite[1] / 100 * 5).round());
    //randomSuite.clear();
  }

  void generateTrash(int nb) {
    for (int i = 0; i < nb; i++) {
      Vector2 position = worldManager.translate(
          chunkPosition,
          Vector2(randomSuite[600 + 2 * i] / 100,
              randomSuite[600 + 2 * i + 1] / 100));
      //debugPrint("generateTrash($i) in $position");
      game.add(Star(gridPosition: position, xOffset: 0));
    }
  }

  void generateBanc(int nb) {
    for (int i = 0; i < nb; i++) {
      Vector2 position = worldManager.translate(
          chunkPosition,
          Vector2(randomSuite[500 + 2 * i] / 100,
              randomSuite[500 + 2 * i + 1] / 100));
      //debugPrint("generateBanc($i) in $position");
      game.add(PlatformBlock(gridPosition: position, xOffset: 0));
    }
  }*/
}
