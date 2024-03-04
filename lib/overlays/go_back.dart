import 'package:ocean_rangers/core/building/building_caracteristic.dart';
import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/core/robot/robot_caracterisitc.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GoBack extends StatelessWidget {
  // Reference to parent game.
  final OceanGame game;
  GoBack({super.key, required this.game});
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
            height: 250,
            width: 500,
            decoration: const BoxDecoration(
              color: blackTextColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Terminate the mission ?',
                  style: TextStyle(
                    color: whiteTextColor,
                    fontSize: 24,
                  ),
                ),
                if (!game.isOnBoat && !isRepechable)
                  const Text(
                    'The self destruc will be triggered !',
                    style: TextStyle(
                      color: whiteTextColor,
                      fontSize: 15,
                    ),
                  ),
                if (!game.isOnBoat && isRepechable)
                  const Text(
                    'The robotic arm can get you here !',
                    style: TextStyle(
                      color: whiteTextColor,
                      fontSize: 15,
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        width: 200,
                        height: 75,
                        child: ElevatedButton(
                          onPressed: () {
                            //game.resumeEngine();
                            game.onPause = false;
                            game.overlays.remove('GoBack');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteTextColor,
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 25.0,
                              color: blackTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 75,
                      child: ElevatedButton(
                        onPressed: () {
                          if (game.isOnBoat || isRepechable) {
                            game.terminateGame(100, true);

                            /*Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => BoatPage()),
                          );*/
                            Navigator.pushReplacementNamed(context, "/boat");
                          } else {
                            game.health = 0;
                            game.onPause = false;
                            game.overlays.remove('GoBack');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteTextColor,
                        ),
                        child: const Text(
                          'Go to ship',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: blackTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  game.ressourceMessage,
                  style: const TextStyle(
                    color: whiteTextColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
