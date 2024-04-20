import 'package:ocean_rangers/core/building/building_caracteristic.dart';
import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/input/keyboard.dart';
import 'package:ocean_rangers/core/robot/robot_caracterisitc.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Infos extends StatelessWidget {
  // Reference to parent game.
  final OceanGame game;
  Infos({super.key, required this.game});
  bool isRepechable = false;

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    if (game.currentDeep <
        GameFile().building.getValue(BuildingCaracteritics.roboticArm)) {
      isRepechable = true;
    }
    if (game.isOnBoat) {
      game.terminateGame(100, false);
    } else if (!isRepechable) {
      game.terminateGame(
          30 * GameFile().robot.getValue(RobotCaracteritics.stockageResistance),
          false);
    }

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: (MediaQuery.of(context).size.height / 2) - 100),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 500,
            width: 500,
            decoration: const BoxDecoration(
              color: blackTextColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to the ocean !',
                    style: TextStyle(
                      color: whiteTextColor,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You control the robot with the keyboard arrow, ${GameFile().keyboardManager.getValue(KeyCaracteritics.goUp)},${GameFile().keyboardManager.getValue(KeyCaracteritics.goLeft)},${GameFile().keyboardManager.getValue(KeyCaracteritics.goDown)},${GameFile().keyboardManager.getValue(KeyCaracteritics.goRight)} (can be changed in the option menu on boat view), or mouse. Your objective is to go to the deepest point',
                      style: const TextStyle(
                        color: whiteTextColor,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'But you need to have enough power to come back with the robot still functioning! (Electrical power on the top left)',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Remember that collecting trash is the only way to earn ressources to upgrade the robot and the ship. These is needed to advance in the game. So do not hesitate to use your ressrouces !',
                      style: TextStyle(
                        color: whiteTextColor,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Good luck, we are counting on you !',
                      style: TextStyle(
                        color: whiteTextColor,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          //game.resumeEngine();
                          game.onPause = false;
                          game.overlays.remove('Infos');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteTextColor,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: blackTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
