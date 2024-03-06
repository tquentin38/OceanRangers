import 'dart:math';

import 'package:ocean_rangers/actors/water_enemy.dart';
import 'package:ocean_rangers/core/building/building_caracteristic.dart';
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
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/trash.dart';
import '../text/text_box.dart';

class OceanPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<OceanGame> {
  double horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  double moveSpeed = 150;
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
  }

  Vector2 screenSize = Vector2(0, 0);
  Vector2 velocityVeforeCameraMove = Vector2(0, 0);

  @override
  void onGameResize(Vector2 size) {
    if (screenSize.x != 0 && size != screenSize) {
      position.x = screenSize.x / 2;
      position.y = screenSize.y / 2;
    }
    //clear velocity
    horizontalDirection = 0;
    velocity.y = 0;
    scale = Vector2(size.x / 1920 / 1.4, size.y / 1080 / 1.4);
    worldManager.onGameResize(size);
    textManager.setBoxPosition(Vector2(size.x / 2 - 400, 100));
    if (screenSize.x == 0) {
      textManager.addTextToDisplay(
          "Radio: Un deux, un deux ! Est-ce que tu m'entends depuis ton poste de contrôle ? Le robot a été déployé, vas-y, c'est a toi ! ",
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
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyQ) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    goUp = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyZ);
    goDown = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    if (keysPressed.contains(LogicalKeyboardKey.keyK)) {
      game.health = 0;
      textManager.addTextToDisplay(
          "Radio: Oh, tu as activé l'auto-destruction ?!? Bon ... bah on vas voir ce qu'on pourra récupérer ... ",
          15,
          true);
    }
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      game.onPause = true;
      game.isOnBoat = false;
      game.overlays.add('GoBack');
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyI)) {
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
    // Composition.
    //
    // Defining a particle effect as a set of nested behaviors from top to bottom,
    // one within another:
    //
    // ParticleSystemComponent
    //   > ComposedParticle
    //     > AcceleratedParticle
    //       > CircleParticle

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
          "Radio: Attention ! Tu as déjà utilisé la moitié de ton énergie !",
          10,
          true);
      halfEnergyWarning = true;
    } else if (!twentyFivePercentEnergyWarning &&
        game.electricalPower < game.maxElectricalPower / 4) {
      textManager.addTextToDisplay(
          "Radio: Plus qu'un quart d'énergie, tu ferais mieux de commencer a remonter !",
          10,
          true);
      twentyFivePercentEnergyWarning = true;
    } else if (!tenPercentEnergyWarning &&
        game.electricalPower < game.maxElectricalPower / 10) {
      textManager.addTextToDisplay(
          "Radio: Ton énergie est critique ! Remonte !", 10, true);
      tenPercentEnergyWarning = true;
    }
    //velocity.x = 0;
    //velocity.y = 0;
    /*
    // Prevent ember from going backwards at screen edge.
    if (position.x - 30 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
      position.x = 30;
    }

bool halfEnergyWarning = false;
  bool twentyFivePercentEnergyWarning = false;
  bool tenPercentEnergyWarning = false;

    if (position.x + 64 > game.size.x * (1 - percentStartMove)) {
      // Prevent ember from going beyond half screen.
      if (position.x + 64 >= game.size.x * (1 - percentMaxMove)) {
        velocity.x = -moveSpeed;
        game.objectSpeed.x = -moveSpeed;
      } else {
        double customMoveSpeed = moveSpeed *
            (position.x + 64) /
            (game.size.x * (1 - percentMaxMove));
        velocity.x = -customMoveSpeed;
        game.objectSpeed.x = -customMoveSpeed;
      }
    }

    //going left
    if (position.x - 64 < game.size.x * percentStartMove) {
      // Prevent ember from going beyond half screen.
      if (position.x - 64 <= game.size.x * percentMaxMove) {
        velocity.x = moveSpeed;
        game.objectSpeed.x = moveSpeed;
      } else {
        double customMoveSpeed = 0.1 +
            moveSpeed *
                (1 -
                    ((position.x - 64 - game.size.x * percentMaxMove) /
                        (game.size.x * (percentStartMove - percentMaxMove))));
        //debugPrint(
        //     "customMoveSpeed : $customMoveSpeed (${(position.x - 64 - game.size.x * percentMaxMove).toStringAsFixed(2)} / ${(game.size.x * (percentStartMove - percentMaxMove)).toStringAsFixed(2)})");
        velocity.x = customMoveSpeed;
        game.objectSpeed.x = customMoveSpeed;
      }
    }

    //going down
    if (position.y + 64 > game.size.y * (1 - percentStartMove)) {
      // Prevent ember from going beyond half screen.
      if (position.y + 64 >= game.size.y * (1 - percentMaxMove)) {
        velocity.y = -moveSpeed;
        game.objectSpeed.y = -moveSpeed;
      } else {
        double customMoveSpeed = moveSpeed *
            (position.y + 64) /
            (game.size.y * (1 - percentMaxMove));
        velocity.y = -customMoveSpeed;
        game.objectSpeed.y = -customMoveSpeed;
      }
    }

    //going up
    if (position.y - 64 < game.size.y * percentStartMove) {
      // Prevent ember from going beyond half screen.
      if (position.y - 64 <= game.size.y * percentMaxMove) {
        //velocity.y = moveSpeed;
        game.objectSpeed.y = moveSpeed;
      } else {
        double customMoveSpeed = 0.1 +
            moveSpeed *
                (1 -
                    ((position.y - 64 - game.size.y * percentMaxMove) /
                        (game.size.y * (percentStartMove - percentMaxMove))));
        //debugPrint(
        //     "customMoveSpeed : $customMoveSpeed (${(position.x - 64 - game.size.x * percentMaxMove).toStringAsFixed(2)} / ${(game.size.x * (percentStartMove - percentMaxMove)).toStringAsFixed(2)})");
        //velocity.y = customMoveSpeed;
        game.objectSpeed.y = customMoveSpeed;
      }
    }

    // Prevent going to up !
    if (position.y - 30 <= 0) {
      position.y = 30;
    }
*/
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
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.5) {
          //isOnGround = true;
        }

        /*Vector2 otherMin = other.position - other.size;
        Vector2 otherMax = other.position + other.size;
        Vector2 myMin = position - size;
        Vector2 myMax = position + size;
        String colisionSide = "idk";

        if (myMin.y < otherMin.y) {
          colisionSide = "+y";
        }
        if (myMax.y > otherMax.y) {
          colisionSide = "-y";
        }

        if (myMin.x < otherMin.x) {
          colisionSide = "+x";
        }
        if (myMax.x > otherMax.x) {
          colisionSide = "-x";
        }*/

        // debugPrint(
        //   "otherMin $otherMin otherMax $otherMax --- myMin ${myMin} myMax ${myMax} - ColizionSide : $colisionSide");

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        game.objectSpeed = game.objectSpeed * 0.25;
        game.objectSpeed -= collisionNormal.scaled(separationDistance);
        if (velocity.y < 0) {
          velocity.y = 0;
        }
      }
    }
    if (other is Trash && (game.health > 0 && game.electricalPower > 0)) {
      if (game.spaceUsed + other.trashType.sizeInInventory <= game.maxSpace) {
        other.removeFromParent();
        other.activated = false;
        game.spaceUsed += other.trashType.sizeInInventory;
        game.trashCollected[other.trashType.identifier]++;
        game.numberOfPoint += other.trashType.pointNumber;
        if (!sendedFirstTrashMessage) {
          textManager.addTextToDisplay(
              "Radio: Hé ! Ici Sam, j'ai vu que tu as récupérer un déchêt bien joué ! ",
              5,
              false);
          sendedFirstTrashMessage = true;
        }
      } else {
        if (!sendedFullMessage) {
          sendedFullMessage = true;
          textManager.addTextToDisplay(
              "Radio: Le robot est plein, tu devrais remonter ! ", 10, true);
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
            "Radio: Fais gaffe ! Ces poissons t'attaquent si tu passes trop prêt ! ",
            5,
            true);
      } else {
        if (game.health > 1) {
          textManager.addTextToDisplay(
              "Radio: Attention !!! Le robot est déjà très endommagé ! ",
              5,
              true);
        } else {
          if (game.health > 0) {
            textManager.addTextToDisplay(
                "Radio: Le robot est vraiment en danger ! Tu ferais mieux de remonté a la surface !!! ",
                10,
                true);
          } else {
            textManager.addTextToDisplay(
                "Radio: Je t'avais dit de faire attention ! Bon, on vas récupérer ce qu'il reste du robot ",
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
