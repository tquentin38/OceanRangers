import 'dart:math';

import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/core/building/building_caracteristic.dart';
import 'package:ocean_rangers/core/input/keyboard.dart';
import 'package:ocean_rangers/main.dart';
import 'package:ocean_rangers/managers/world_manager.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/game_file.dart';
import '../core/robot/robot_caracterisitc.dart';
import '../objects/trash.dart';
import '../text/text_box.dart';

class OceanPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<OceanGame> {
  double horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  double moveSpeed = 150; //150
  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  double gravity = 1.5;
  double jumpSpeed = 150; //150
  double terminalVelocity = 200; //200
  final double percentStartMove = 35 / 100;
  final double percentMaxMove = 30 / 100;
  bool hitByEnemy = false;
  bool goUp = false;
  bool goDown = false;
  final WorldManager worldManager;
  double electricalFactor = 0.01;
  bool halfEnergyWarning = false;
  bool twentyFivePercentEnergyWarning = false;
  bool tenPercentEnergyWarning = false;
  bool sendedFullMessage = false;
  bool sendedFirstTrashMessage = false;

  LogicalKeyboardKey? openInfoKey;
  LogicalKeyboardKey? goUpKey;
  LogicalKeyboardKey? goDownKey;
  LogicalKeyboardKey? goRightKey;
  LogicalKeyboardKey? goLeftKey;

  TextManager textManager = TextManager();
  OceanPlayer({required super.position, required this.worldManager})
      : super(size: Vector2(154, 154), anchor: Anchor.center, priority: 1);

  @override
  void onLoad() {
    moveSpeed *= GameFile().robot.getValue(RobotCaracteritics.acceleration);
    jumpSpeed *= GameFile().robot.getValue(RobotCaracteritics.acceleration);
    terminalVelocity *= GameFile().robot.getValue(RobotCaracteritics.speed);
    electricalFactor *=
        GameFile().robot.getValue(RobotCaracteritics.motorEfficiency);
    textManager.setGame(game);
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('sous_marin.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(200, 200),
        stepTime: 0.12,
      ),
    );
    add(RectangleHitbox());
    for (LogicalKeyboardKey logicalKeyboardKey
        in LogicalKeyboardKey.knownLogicalKeys) {
      if (logicalKeyboardKey.keyLabel ==
          GameFile().keyboardManager.getValue(KeyCaracteritics.info)) {
        openInfoKey = logicalKeyboardKey;
      }
      if (logicalKeyboardKey.keyLabel ==
          GameFile().keyboardManager.getValue(KeyCaracteritics.goUp)) {
        goUpKey = logicalKeyboardKey;
      }
      if (logicalKeyboardKey.keyLabel ==
          GameFile().keyboardManager.getValue(KeyCaracteritics.goDown)) {
        goDownKey = logicalKeyboardKey;
      }
      if (logicalKeyboardKey.keyLabel ==
          GameFile().keyboardManager.getValue(KeyCaracteritics.goRight)) {
        goRightKey = logicalKeyboardKey;
      }
      if (logicalKeyboardKey.keyLabel ==
          GameFile().keyboardManager.getValue(KeyCaracteritics.goLeft)) {
        goLeftKey = logicalKeyboardKey;
      }
    }
    openInfoKey ??= LogicalKeyboardKey.keyI;
    goUpKey ??= LogicalKeyboardKey.keyZ;
    goDownKey ??= LogicalKeyboardKey.keyS;
    goRightKey ??= LogicalKeyboardKey.keyD;
    goLeftKey ??= LogicalKeyboardKey.keyQ;
  }

  Vector2 screenSize = Vector2(0, 0);
  Vector2 velocityVeforeCameraMove = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      position.x = screenSize.x / 2;
      position.y = screenSize.y / 2;
    }
    Vector2 scaleImg = Vector2(size.x, size.y);
    if (scaleImg.x > 1920) {
      scaleImg.x = 1920;
    }
    if (scaleImg.y > 1080) {
      scaleImg.y = 1080;
    }

    if (scaleImg.x < scaleImg.y) {
      scaleImg.y = scaleImg.x * 1080 / 1920;
    } else {
      scaleImg.x = scaleImg.y * 1920 / 1080;
    }

    //clear velocity
    horizontalDirection = 0;
    velocity.y = 0;
    scale = Vector2(scaleImg.x / 1920 / 1.4, scaleImg.y / 1080 / 1.4);
    worldManager.onGameResize(size);
    textManager.setBoxPosition(Vector2(size.x / 2 - 400, 100));
    if (screenSize.x == 0) {
      textManager.addTextToDisplay(
          "Radio: One two, one two! Can you hear me from your control station? The robot has been deployed, go ahead, it's your turn!",
          15,
          true);
    }
    screenSize = size;
    debugPrint("onGameresize $size from player ! ");
    super.onGameResize(size);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(goLeftKey) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(goRightKey) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    goUp = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(goUpKey);
    goDown = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(goDownKey);
    /* if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      game.health = 0;
      textManager.addTextToDisplay(
          "Radio: Oh, you activated the self-destruct?!? Well... let's see what we can salvage...",
          15,
          true);
    }*/
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      game.onPause = true;
      game.isOnBoat = false;
      game.overlays.add('GoBack');
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
      game.onPause = true;
      game.isOnBoat = false;
      game.overlays.add('GoBack');
    }
    if (keysPressed.contains(openInfoKey)) {
      game.onPause = true;
      game.isOnBoat = false;
      game.overlays.add('Infos');
    }
    return true;
  }

  bool wasTap = false;
  void checkTap() {
    if (MouseInfos().isTap) {
      wasTap = true;
      horizontalDirection = 0;
      goUp = false;
      goDown = false;

      if (MouseInfos().position.y > screenSize.y / 2) {
        goDown = true;
      } else if (MouseInfos().position.y < screenSize.y / 2) {
        goUp = true;
      }

      if (MouseInfos().position.x > screenSize.x / 2 + screenSize.x * 0.03) {
        if (MouseInfos().position.x > screenSize.x / 2 + screenSize.x / 4) {
          horizontalDirection = 1;
        } else {
          horizontalDirection = 1 *
              (1 -
                  ((screenSize.x / 2 +
                          screenSize.x / 4 -
                          MouseInfos().position.x) /
                      (screenSize.x / 4)));
          //debugPrint(
          //    "$horizontalDirection (${screenSize.x / 2 + screenSize.x / 4 - MouseInfos().position.x}/${screenSize.x / 4})");
        }
      } else if (MouseInfos().position.x <
          screenSize.x / 2 - screenSize.x * 0.03) {
        if (MouseInfos().position.x < screenSize.x / 4) {
          horizontalDirection = -1;
        } else {
          horizontalDirection = -1 *
              ((screenSize.x / 2 - MouseInfos().position.x) /
                  (screenSize.x / 4));
          //debugPrint(
          //    "$horizontalDirection (${screenSize.x / 2 - MouseInfos().position.x}/${screenSize.x / 4})");
        }
      }
    } else if (wasTap) {
      wasTap = true;
      horizontalDirection = 0;
      goUp = false;
      goDown = false;
      wasTap = false;
    }
  }

  Random rnd = Random();
  Vector2 newRandomVector() {
    double randomNumber = (50 + rnd.nextInt(100)) / 150;
    double randomNumber2 = (50 + rnd.nextInt(50)) / 150;

    double randomAddX = rnd.nextDouble() * 10;
    double randomAddY = rnd.nextDouble() * 10;

    Vector2 randVect = Vector2(
        (velocityVeforeCameraMove.x * 5 + randomAddX) * -1 * randomNumber,
        (velocityVeforeCameraMove.y * 50 + 1 + randomAddY) *
            -0.1 *
            randomNumber2);

    return randVect;
  }

  double lastHorizontalDirection = 1;
  void generateParticules() {
    if (rnd.nextInt(7) < 6) {
      return;
    }

    Vector2 posPart = position.clone();
    if (horizontalDirection != 0) {
      lastHorizontalDirection = horizontalDirection;
    }
    if (lastHorizontalDirection > 0) {
      posPart.add(Vector2(-50, 0));
    } else {
      posPart.add(Vector2(50, 0));
    }
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 1,
          generator: (i) => AcceleratedParticle(
            acceleration: newRandomVector(),
            position: posPart,
            child: CircleParticle(
              paint: Paint()..color = const Color.fromARGB(255, 68, 0, 255),
              radius: 5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    if (game.onPause) return;
    if (game.health > 0 && game.electricalPower > 0) {
      checkTap();
      velocity.x = horizontalDirection * moveSpeed;
      game.electricalPower -= (velocity.x * dt * electricalFactor).abs();
      //position += velocity * dt;

      // Apply basic gravity
      if (!isOnGround) {
        if (!goDown) {
          if (velocity.y < 0) {
            velocity.y += gravity;
          } else {
            velocity.y += gravity *
                GameFile().robot.getValue(RobotCaracteritics.stabilisator);
          }
        }
      } else {
        velocity.y = 0;
      }

      // Determine X axis mouvement up
      if (goUp && !goDown) {
        if (isOnGround) {
          isOnGround = false;
        }
        velocity.y = -jumpSpeed;
        game.electricalPower -= (velocity.y * dt * electricalFactor).abs();
      }
      //and down
      if (goDown && !goUp) {
        velocity.y += jumpSpeed;
        game.electricalPower -= (velocity.y * dt * electricalFactor).abs();
      }
      //and if both key is pressed, we stay
      if (goDown && goUp) {
        if (velocity.y > 0) {
          velocity.y -= 5;
        } else {
          velocity.y += 5;
        }

        if (velocity.y.abs() < 5) {
          velocity.y = 0;
        }
      }

      // Prevent ember from jumping to crazy fast as well as descending too fast and
      // crashing through the ground or a platform.
      if (goDown || goUp) {
        isOnGround = false;
        velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);
      } else {
        velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity / 4);
      }
      velocityVeforeCameraMove = Vector2(velocity.x, velocity.y);
      //generate move particule
      if (velocity.x.abs() > 1 || goDown || goUp) {
        //velocityVeforeCameraMove.add(Vector2(-game.objectSpeed.x * 3, 0));
        generateParticules();
      }

      // super.update(dt);

      if (horizontalDirection < 0 && scale.x > 0) {
        flipHorizontally();
      } else if (horizontalDirection > 0 && scale.x < 0) {
        flipHorizontally();
      }

      game.objectSpeed.x = velocity.x * -1;
      game.objectSpeed.y = velocity.y * -1;
    }

    //on death or no energie
    if (game.health == 0 || game.electricalPower <= 0) {
      game.terminateGame(
          30 * GameFile().robot.getValue(RobotCaracteritics.stockageResistance),
          true);
      GameFile().setNextRobotAvaiable(DateTime.now().add(Duration(
          seconds: (30 *
                  GameFile()
                      .building
                      .getValue(BuildingCaracteritics.repairStation))
              .toInt())));
      game.objectSpeed.y = 100 * worldManager.getDeep();
      game.objectSpeed.x = 0;
      if (game.electricalPower <= 0) {
        game.electricalPower = 0;
      }
    }

    if (worldManager.getPosition().y + game.objectSpeed.y >= 0) {
      game.objectSpeed.y = 0 - worldManager.getPosition().y;
    }

    worldManager.update(game.objectSpeed * dt);
    super.update(dt);

    if (worldManager.isPlayerWantToGoBack() &&
        game.health > 0 &&
        game.electricalPower > 0) {
      //game.pauseEngine();
      game.onPause = true;
      game.isOnBoat = true;
      game.overlays.add('GoBack');
      worldManager.resetPlayerGoBack();
    }

    if (!halfEnergyWarning &&
        game.electricalPower < game.maxElectricalPower / 2) {
      textManager.addTextToDisplay(
          "Radio: Attention! You have already used half of your energy!",
          10,
          true);
      halfEnergyWarning = true;
    } else if (!twentyFivePercentEnergyWarning &&
        game.electricalPower < game.maxElectricalPower / 4) {
      textManager.addTextToDisplay(
          "Radio: Less than a quarter of energy left, you'd better start heading back up!",
          10,
          true);
      twentyFivePercentEnergyWarning = true;
    } else if (!tenPercentEnergyWarning &&
        game.electricalPower < game.maxElectricalPower / 10) {
      textManager.addTextToDisplay(
          "Radio: Your energy is critical! Get back up!", 10, true);
      tenPercentEnergyWarning = true;
    }

    // If ember fell in pit, then game over.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    /*if (game.health <= 0) {
      removeFromParent();
    }*/

    if (isOnGround) {
      velocity.y = 0;
    }
    //position += velocity * dt;

    //super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Trash && (game.health > 0 && game.electricalPower > 0)) {
      if (game.spaceUsed + other.trashType.sizeInInventory <= game.maxSpace) {
        other.removeFromParent();
        other.activated = false;
        game.spaceUsed += other.trashType.sizeInInventory;
        game.trashCollected[other.trashType.identifier]++;
        game.numberOfPoint += other.trashType.pointNumber;
        if (!sendedFirstTrashMessage) {
          textManager.addTextToDisplay(
              "Radio: Hey! This is Sam. I saw that you picked up some debris, well done!",
              5,
              false);
          sendedFirstTrashMessage = true;
        }
      } else {
        if (!sendedFullMessage) {
          sendedFullMessage = true;
          textManager.addTextToDisplay(
              "Radio: The robot is full, you should head back up!", 10, true);
        }
      }
    }

    if (other is WaterEnemy) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  // This method runs an opacity effect on ember
// to make it blink.
  void hit() {
    if (!hitByEnemy && (game.health > 0 && game.electricalPower > 0)) {
      hitByEnemy = true;
      game.health--;
      if (game.health > 2) {
        textManager.addTextToDisplay(
            "Radio: Watch out! These fish will attack if you get too close! ",
            5,
            true);
      } else {
        if (game.health > 1) {
          textManager.addTextToDisplay(
              "Radio: Attention! The robot is already very damaged!", 5, true);
        } else {
          if (game.health > 0) {
            textManager.addTextToDisplay(
                "Radio: The robot is really in danger! You better head back up to the surface!!!",
                10,
                true);
          } else {
            textManager.addTextToDisplay(
                "Radio: I told you to be careful! Well, we're going to retrieve whatever is left of the robot.",
                10,
                true);
          }
        }
      }
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }
}
