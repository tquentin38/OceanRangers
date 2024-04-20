import 'dart:math';

import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/managers/world_manager.dart';
import 'package:ocean_rangers/objects/fish.dart';
import 'package:ocean_rangers/objects/game_object.dart';
import 'package:ocean_rangers/objects/trash.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FishTypeHolder {
  final FishType fishType;
  final double percent;
  FishTypeHolder({required this.fishType, required this.percent});
}

class TrashTypeHolder {
  final TrashType trashType;
  final double percent;
  TrashTypeHolder({required this.trashType, required this.percent});
}

class EnemyTypeHolder {
  final WaterEnemyType waterEnemyType;
  final double percent;
  EnemyTypeHolder({required this.waterEnemyType, required this.percent});
}

class Chunk {
  Vector2 chunkPosition;
  Vector2 chunkPositionToZero = Vector2(0, 0);
  int mainSeed;
  WorldManager worldManager;
  OceanGame game;
  int currentSeed = 0;
  late Random random;
  List<double> randomSuite = [];
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
      randomSuite.add(random.nextDouble() * 100);
    }
  }

  void resize(Vector2 ratio) {
    for (PreLoadedGameObject preLoadedGameObject in preLoadedGameObjects) {
      preLoadedGameObject.updateFuturPosition(ratio.x, ratio.y);
    }
    List<GameObject> toRemove = [];
    for (GameObject gameObject in loadedBlocks) {
      gameObject.preLoadedGameObject.updateFuturPosition(ratio.x, ratio.y);

      gameObject.removeObject();
      preLoadedGameObjects.add(gameObject.getPreLoadedGameObject());
      toRemove.add(gameObject);
    }

    for (GameObject removable in toRemove) {
      loadedBlocks.remove(removable);
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
            TrashType? trashType = getTrashType(
                chunkPosition.y * 20,
                preLoadedGameObject.randomDouble,
                preLoadedGameObject.secondRandomDouble);
            if (trashType == null) {
              //debugPrint(
              //    "trashType == null depth:${chunkPosition.y * 20} ${preLoadedGameObject.futurPosition}");
            } else {
              Trash trash = Trash(
                  gridPosition: delta + preLoadedGameObject.futurPosition,
                  preLoadedGameObject: preLoadedGameObject,
                  trashType: TrashType.values[
                      (preLoadedGameObject.randomDouble /
                              100 *
                              (TrashType.values.length - 1))
                          .round()]);
              game.add(trash);
              // trash.onGameResize(worldManager.screenSize);
              loadedBlocks.add(trash);
              //debugPrint("added Trash ${preLoadedGameObject.futurPosition}");
              toRemove.add(preLoadedGameObject);
            }
            break;
          case GameObjectType.fish:
            FishType? fishType = getFishType(
                chunkPosition.y * 20, preLoadedGameObject.randomDouble);
            if (fishType == null) {
              debugPrint(
                  "fishType == null depth:${chunkPosition.y * 20} ${preLoadedGameObject.futurPosition}");
            } else {
              Fish fish = Fish(
                  gridPosition: delta + preLoadedGameObject.futurPosition,
                  preLoadedGameObject: preLoadedGameObject,
                  fishType: FishType.values[(preLoadedGameObject.randomDouble /
                          100 *
                          (FishType.values.length - 1))
                      .round()]);
              //debugPrint(
              //    "added  PlatformBlock ${preLoadedGameObject.futurPosition}");
              game.add(fish);
              //fish.onGameResize(worldManager.screenSize);
              loadedBlocks.add(fish);
              toRemove.add(preLoadedGameObject);
            }
            break;
          case GameObjectType.enemy:
            WaterEnemyType? waterEnemyType = getWaterEnemyType(
                chunkPosition.y * 20, preLoadedGameObject.randomDouble);
            if (waterEnemyType == null) {
              debugPrint(
                  "waterEnemyType == null depth:${chunkPosition.y * 20} ${preLoadedGameObject.futurPosition}");
            } else {
              WaterEnemy waterEnemy = WaterEnemy(
                  gridPosition: delta + preLoadedGameObject.futurPosition,
                  preLoadedGameObject: preLoadedGameObject,
                  waterEnemyType: waterEnemyType);
              //debugPrint(
              //    "added  WaterEnemy ${preLoadedGameObject.futurPosition}");
              game.add(waterEnemy);
              //waterEnemy.onGameResize(worldManager.screenSize);
              loadedBlocks.add(waterEnemy);
              toRemove.add(preLoadedGameObject);
            }

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
    double bancRand = randomSuite[0];

    //generate number of fish banc type 1 - moy 10 in level 0m, 0 in level 100m

    preGenerateFish(10 + (bancRand / 100 * 10).round());

    preGenerateTrash(25 + (randomSuite[1] / 100 * 2).round());

    if (chunkPosition.y * 20 > 50) preGenerateEnemy(5);
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
          position,
          GameObjectType.trash,
          randomSuite[700 + 2 * i],
          randomSuite[800 + 2 * i]));
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
          position,
          GameObjectType.enemy,
          randomSuite[500 + 2 * i],
          randomSuite[600 + 2 * i]));
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
          position,
          GameObjectType.fish,
          randomSuite[300 + 2 * i],
          randomSuite[400 + 2 * i]));
    }
  }

  FishType? getFishType(double depth, double random) {
    List<FishTypeHolder> list = getFishTypes(depth);
    double current = 0;
    //get all percentage
    for (FishTypeHolder et in list) {
      current += et.percent;
    }
    //applie random
    double value = current * random / 100;
    current = 0;
    //find the random one
    for (FishTypeHolder et in list) {
      current += et.percent;
      if (current > value) {
        return et.fishType;
      }
    }
    //if nothing return null
    return null;
  }

  List<FishTypeHolder> getFishTypes(double meter) {
    List<FishTypeHolder> list = [];
    for (FishType ft in FishType.values) {
      //if we are on the spawn plage
      if (ft.deepMax >= meter && meter >= ft.deepMin) {
        if (meter >= ft.deepPeak) {
          list.add(FishTypeHolder(
              fishType: ft,
              percent: 100 *
                  (1 + (ft.deepPeak - meter) / (ft.deepMax - ft.deepPeak))));
        } else {
          list.add(FishTypeHolder(
              fishType: ft,
              percent: 100 *
                  (1 - (ft.deepPeak - meter) / (ft.deepPeak - ft.deepMin))));
        }
      }
    }
    return list;
  }

  TrashType? getTrashType(double depth, double random, double secondRandom) {
    List<TrashTypeHolder> list = getTrashTypes(depth);
    double current = 0;
    //get all percentage
    for (TrashTypeHolder et in list) {
      current += et.percent;
    }
    //applie random
    double value = current * random / 100;
    current = 0;
    //find the random one
    for (TrashTypeHolder et in list) {
      current += et.percent;
      if (current > value) {
        //apply rarity factor
        if (secondRandom / 100 < et.trashType.rarityFactor) {
          return et.trashType;
        } else {
          return null;
        }
      }
    }
    //if nothing return null
    return null;
  }

  List<TrashTypeHolder> getTrashTypes(double meter) {
    List<TrashTypeHolder> list = [];
    for (TrashType tt in TrashType.values) {
      //if we are on the spawn plage
      if (tt.deepMax >= meter && meter >= tt.deepMin) {
        if (meter >= tt.deepPeak) {
          list.add(TrashTypeHolder(
              trashType: tt,
              percent: 100 *
                  (1 + (tt.deepPeak - meter) / (tt.deepMax - tt.deepPeak))));
        } else {
          list.add(TrashTypeHolder(
              trashType: tt,
              percent: 100 *
                  (1 - (tt.deepPeak - meter) / (tt.deepPeak - tt.deepMin))));
        }
      }
    }
    return list;
  }

  WaterEnemyType? getWaterEnemyType(double depth, double random) {
    List<EnemyTypeHolder> list = getWaterEnemyTypes(depth);
    double current = 0;
    //get all percentage
    for (EnemyTypeHolder et in list) {
      current += et.percent;
    }
    //applie random
    double value = current * random / 100;
    current = 0;
    //find the random one
    for (EnemyTypeHolder et in list) {
      current += et.percent;
      if (current > value) {
        return et.waterEnemyType;
      }
    }

    if (list.isNotEmpty) {
      return list.first.waterEnemyType;
    }
    //if nothing return null
    return null;
  }

  List<EnemyTypeHolder> getWaterEnemyTypes(double meter) {
    List<EnemyTypeHolder> list = [];
    for (WaterEnemyType tt in WaterEnemyType.values) {
      //if we are on the spawn plage
      if (tt.deepMax >= meter && meter >= tt.deepMin) {
        if (meter >= tt.deepPeak) {
          list.add(EnemyTypeHolder(
              waterEnemyType: tt,
              percent: 100 *
                  (1 + (tt.deepPeak - meter) / (tt.deepMax - tt.deepPeak))));
        } else {
          list.add(EnemyTypeHolder(
              waterEnemyType: tt,
              percent: 100 *
                  (1 - (tt.deepPeak - meter) / (tt.deepPeak - tt.deepMin))));
        }
      }
    }
    return list;
  }
}
