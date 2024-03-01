import 'package:challenge2024/actors/ocean_player.dart';
import 'package:challenge2024/core/building/building_caracteristic.dart';
import 'package:challenge2024/core/game_file.dart';
import 'package:challenge2024/core/ressources/ressource.dart';
import 'package:challenge2024/core/robot/robot_caracterisitc.dart';
import 'package:challenge2024/core/stats/stats.dart';
import 'package:challenge2024/managers/world_manager.dart';
import 'package:challenge2024/overlays/hud.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'objects/trash.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';

import 'overlays/background.dart';

class OceanGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late OceanPlayer _ember;
  late BackgroundComponent _background;
  late WorldManager _worldManager;
  bool isInit = false;
  Vector2 objectSpeed = Vector2(0, 0);
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  int numberOfPoint = 0;
  int spaceUsed = 0;
  int maxSpace = 40;
  int health = 10;
  int maxHealth = 10;
  double energie = 100;
  double maxDeep = 0;
  double currentDeep = 0;
  double electricalPower = 100;
  double maxElectricalPower = 100;
  List<int> trashCollected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  bool terminatedComputed = false;
  String ressourceMessage = "";
  bool isTapping = false;
  Vector2 mousePosition = Vector2(0, 0);
  bool isOnBoat = false;
  bool onPause = false;
  bool hasPlayedDeadSound = false;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 98, 96, 243);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      /*'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',*/
      'light_fishs.png',
      'player_fishs.png',
      'fish_1s.png',
      'dead_fish2s.png',
      'dead_fishs.png',
      'conserves.png',
      'submarines.png',
      'banc_s.png',
      'ship_s.png',
      'ship_m.png',
      'couvert_s.png',
      'bouteille_s.png',
      'canette_s.png',
      'gobelet_s.png',
      'gourde_s.png',
      'sac_plastique_s.png',
      'sous_marin.png',
      'bateau_r.png',
      'bateau_l.png',
      'bateau.png',
      'sac_plastique_s.png',
      'ancre.jpg',
      'robot.png',
      //new fishs
      'fish_1.png',
      'fish_2.png',
      'fish_3.png',
      'fish_4.png',
      'fish_5.png',
      'fish_6.png',
      'fish_7.png',
      'fish_8.png',
      'fish_9.png',
      'fish_10.png',
      'fish_11.png',
      'fish_12.png',
      'fish_13.png',
      'fish_14.png',
      'fish_15.png',
      'fish_16.png',
      'banc_poisson.png',
      'Blue_Whale.png',
      'dauphin.png',
      'Manta_Ray.png',
      'piranha.png',
      'tortue.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;
    //init gamefile
    GameFile();

    initializeGame(true);
  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    if (isInit) _worldManager.onGameResize(size);
    super.onGameResize(size);
  }

  /*//Targeted 1920 x 1080
  @override
  void render(Canvas c) {
    c.save();

    double resizeX = 0;
    double resizeY = 0;
    if (size.x > 1920) {
      resizeX = (size.x - 1920) / 2;
    }
    if (size.y > 1080) {
      resizeY = (size.y - 1080) / 2;
    }
    // the variables resizeOffset and scale I set according to the screen size
    c.translate(resizeX, resizeY);
    c.scale(size.x / 1920, size.y / 1080);

    renderGame(c);

    c.restore();

  }*/

  void initializeGame(bool loadHud) {
    maxSpace = GameFile().getContainerSize();
    electricalPower = electricalPower *
        GameFile().robot.getValue(RobotCaracteritics.batteryPack);
    maxElectricalPower = maxElectricalPower *
        GameFile().robot.getValue(RobotCaracteritics.batteryPack);
    maxHealth = (maxHealth * GameFile().robot.getValue(RobotCaracteritics.life))
        .toInt();
    health = maxHealth;
    maxSpace =
        (maxSpace * GameFile().robot.getValue(RobotCaracteritics.stockageSize))
            .round();
    _worldManager = WorldManager(world, this);
    _worldManager.setupStart();
    // Assume that size.x < 3200
    /*final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }*/

    _ember = OceanPlayer(
      position: Vector2(size.x / 2, size.y / 2),
      worldManager: _worldManager,
    );
    add(_ember);
    _background = BackgroundComponent();
    add(_background);
    if (loadHud) {
      add(Hud(worldManager: _worldManager));
    }
    isInit = true;
    hasPlayedDeadSound = false;
    loadAudio();
  }

  void loadAudio() async {
    await FlameAudio.audioCache.load('dead.mp3');
  }

  void terminateGame(double percentOfTrash, bool givePlayer) {
    if (terminatedComputed) return;
    ressourceMessage = "";
    List<int> ressourcesCollected = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (TrashType trashType in TrashType.values) {
      int nb = trashCollected[trashType.identifier];
      if (nb != 0) {
        for (RessourceHolder ressourceHolder in trashType.grant) {
          ressourcesCollected[ressourceHolder.type.identifier] +=
              ressourceHolder.value;
        }
      }
    }

    int maxRes = (GameFile().boatContainerSize *
            GameFile().building.getValue(BuildingCaracteritics.boatStockage))
        .toInt();
    for (RessourcesTypes ressourcesTypes in RessourcesTypes.values) {
      int nb = (ressourcesCollected[ressourcesTypes.identifier] *
              GameFile().building.getValue(BuildingCaracteritics.recycleur) *
              percentOfTrash /
              100)
          .round();
      if (nb != 0) {
        if (ressourceMessage.length == 0) {
          ressourceMessage += "${ressourcesTypes.name}:$nb ";
        } else {
          ressourceMessage += ", ${ressourcesTypes.name}:$nb ";
        }
        if (givePlayer) {
          debugPrint("GIVE PLAYER ${ressourcesTypes.name}");
          debugPrint(
              "Gamefile Value : ${GameFile().ressourcesManager.get(ressourcesTypes)}");
          debugPrint("NB $nb");
          debugPrint("maxRes $maxRes");
          if (GameFile().ressourcesManager.get(ressourcesTypes) + nb >=
              maxRes) {
            GameFile().ressourcesManager.add(ressourcesTypes,
                maxRes - GameFile().ressourcesManager.get(ressourcesTypes));
          } else {
            GameFile().ressourcesManager.add(ressourcesTypes, nb);
          }
        }
      }
    }
    if (ressourceMessage.isNotEmpty) {
      ressourceMessage = "Collected : $ressourceMessage ($percentOfTrash%)";
    }
    if (givePlayer) {
      GameFile()
          .statsManager
          .add(StatsTypes.trashCollected, numberOfPoint as double);
      GameFile()
          .statsManager
          .add(StatsTypes.powerConsumed, maxElectricalPower - electricalPower);
      if (maxDeep > GameFile().statsManager.get(StatsTypes.deepestPoint) &&
          percentOfTrash >= 100) {
        GameFile().statsManager.set(StatsTypes.deepestPoint, maxDeep);
      }
      terminatedComputed = true;
      GameFile().synchronize();
    }
  }

  void reset() {
    spaceUsed = 0;
    health = 4;
    initializeGame(false);
  }

  @override
  void update(double dt) {
    if (_worldManager.getDeep().abs() > maxDeep) {
      maxDeep = _worldManager.getDeep().abs();
    }
    currentDeep = _worldManager.getDeep().abs();
    if (health <= 0 || electricalPower <= 0) {
      overlays.add('GameOver');
      // For shorter reused audio clips, like sound effects
      if (!hasPlayedDeadSound) {
        FlameAudio.play('dead.mp3');
        hasPlayedDeadSound = true;
      }
    }
    if (isInit) _background.updateColor(_worldManager.getDeep());
    //if (isInit) _worldManager.update(objectSpeed);
    super.update(dt);
  }
}
