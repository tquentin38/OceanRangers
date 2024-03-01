import 'dart:async';

import 'package:challenge2024/boat/boat_dialog.dart';
import 'package:challenge2024/boat/boat_hud.dart';
import 'package:challenge2024/core/people/people_manager.dart';
import 'package:challenge2024/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class WheelHouses extends StatefulWidget {
  const WheelHouses({super.key});

  @override
  State<WheelHouses> createState() => _WheelHousesState();
}

class _WheelHousesState extends State<WheelHouses> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle titleSize = const TextStyle(fontSize: 25);
  TextStyle normalSize = const TextStyle(fontSize: 15);
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  bool showBoatDialog = false;
  BoatDialog? boatDialog;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double mouseX = 0.0;
  double mouseY = 0.0;

  // fetches mouse pointer location
  void _updatelocation(PointerHoverEvent details) {
    setState(() {
      mouseX = details.position.dx;
      mouseY = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage("assets/images/commanderie.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      const BoatHUD(),
      Positioned(
          top: MediaQuery.of(context).size.height / 2 +
              MediaQuery.of(context).size.height / 8 -
              50,
          right: MediaQuery.of(context).size.width / 2.5 +
              MediaQuery.of(context).size.width / 6 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          top: MediaQuery.of(context).size.height / 3 +
              MediaQuery.of(context).size.height / 8 -
              50,
          left: 0 + MediaQuery.of(context).size.width / 12 - 50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 3,
          top: MediaQuery.of(context).size.height / 2,
          right: MediaQuery.of(context).size.width / 2.5,
          child: GestureDetector(
            onTap: () {
              showDialog(context: context, builder: showStats);
            },
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Boat control";
                setState(() {});
              },
              onExit: (event) {
                isHover = false;
                setState(() {});
              },
              onHover: _updatelocation,
            ),
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width / 3,
          left: MediaQuery.of(context).size.height / 30,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              if (showBoatDialog) {
                boatDialog = null;
                showBoatDialog = false;
              } else {
                boatDialog = BoatDialog(
                    dialogs: GameFile()
                        .peopleManager
                        .getDialog(PeopleDialog.commandante));
                showBoatDialog = true;

                Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
                  if (boatDialog == null) {
                    t.cancel();
                  } else {
                    if (boatDialog!.isEnded()) {
                      t.cancel();
                      boatDialog = null;
                      showBoatDialog = false;
                    }
                  }
                });
              }
              setState(() {});
            },
            child: MouseRegion(
                hitTestBehavior: HitTestBehavior.opaque,
                cursor: SystemMouseCursors.click,
                onEnter: (event) {
                  isHover = true;
                  hoverValue = "Talk";
                  setState(() {});
                },
                onExit: (event) {
                  isHover = false;
                  setState(() {});
                },
                onHover: _updatelocation,
                child: const Image(
                  image: AssetImage("assets/images/commandante.png"),
                  fit: BoxFit.fill,
                )),
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 3,
          right: MediaQuery.of(context).size.height / 10,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              if (showBoatDialog) {
                boatDialog = null;
                showBoatDialog = false;
              } else {
                boatDialog = BoatDialog(
                    dialogs: GameFile()
                        .peopleManager
                        .getDialog(PeopleDialog.second));
                showBoatDialog = true;

                Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
                  if (boatDialog == null) {
                    t.cancel();
                  } else {
                    if (boatDialog!.isEnded()) {
                      t.cancel();
                      boatDialog = null;
                      showBoatDialog = false;
                    }
                  }
                });
              }
              setState(() {});
            },
            child: MouseRegion(
                hitTestBehavior: HitTestBehavior.opaque,
                cursor: SystemMouseCursors.click,
                onEnter: (event) {
                  isHover = true;
                  hoverValue = "Talk";
                  setState(() {});
                },
                onExit: (event) {
                  isHover = false;
                  setState(() {});
                },
                onHover: _updatelocation,
                child: const Image(
                  image: AssetImage("assets/images/seconde.png"),
                  fit: BoxFit.fill,
                )),
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 6,
          top: MediaQuery.of(context).size.height / 3,
          left: 0,
          child: GestureDetector(
            onTap: () => {Navigator.pushReplacementNamed(context, "/boat")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go back";
                setState(() {});
              },
              onExit: (event) {
                isHover = false;
                setState(() {});
              },
              onHover: _updatelocation,
            ),
          )),
      if (isHover)
        Positioned(
          top: mouseY + 10,
          left: mouseX + 10,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                hoverValue,
                style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      if (showBoatDialog) boatDialog!,
    ]);
  }

  Widget showStats(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          children: [
            Expanded(
              child: Text(
                "Global stats",
                style: titleSize,
              ),
            ),
            for (StatsHolder statsHolder in GameFile().statsManager.statistics)
              Expanded(
                child: Text(
                  "${statsHolder.type.name}: ${statsHolder.value.toInt()}",
                  style: normalSize,
                ),
              ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close stats",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
