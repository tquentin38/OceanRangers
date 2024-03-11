import 'dart:async';

import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/building/building_caracteristic.dart';
import '../core/game_file.dart';

class BoatMachines extends StatefulWidget {
  const BoatMachines({super.key});

  @override
  State<BoatMachines> createState() => _BoatMachinesState();
}

class _BoatMachinesState extends State<BoatMachines> {
  bool seenIntro = GameFile().seenIntro;
  bool showBoatDialog = false;
  TextStyle titleSize = const TextStyle(fontSize: 25);
  TextStyle normalSize = const TextStyle(fontSize: 15);
  bool isHover = false;
  String hoverValue = "Error: no hover !";
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
            image: AssetImage("assets/images/tech_room.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      const BoatHUD(),
      Positioned(
          top: MediaQuery.of(context).size.height / 8 +
              MediaQuery.of(context).size.height / 6 -
              50,
          left: 0 + MediaQuery.of(context).size.width / 7 - 50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 4,
          right: MediaQuery.of(context).size.height / 20,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              if (showBoatDialog) {
                boatDialog = null;
                showBoatDialog = false;
              } else {
                boatDialog = BoatDialog(
                    dialogHolder: GameFile()
                        .peopleManager
                        .getDialog(PeopleDialog.ouvrier));
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
                  image: AssetImage("assets/images/ouvier.png"),
                  fit: BoxFit.fill,
                )),
          )),
      Positioned(
          bottom: 0 + MediaQuery.of(context).size.height / 8 - 50,
          left: MediaQuery.of(context).size.width / 2.5 +
              MediaQuery.of(context).size.width / 8 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2.5,
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
      Positioned(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 3.5,
          top: MediaQuery.of(context).size.height / 8,
          left: 0,
          child: GestureDetector(
            onTap: () => {
              Navigator.pushReplacementNamed(context, "/boat/machine/batiment")
            },
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Boat upgrade";
                setState(() {});
              },
              onExit: (event) {
                isHover = false;
                setState(() {});
              },
              onHover: _updatelocation,
            ),
          )),
      if (showBoatDialog) boatDialog!,
    ]);
  }

  Widget showStats(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "Boat",
                style: titleSize,
              ),
              for (BuildingCaracteritic bc
                  in GameFile().building.buildingCaracteristics)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(), color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              bc.getName(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${bc.getLevel()}/${bc.getLevelMax()} améliorations",
                            ),
                            Text(bc.getNeededForUpgrade()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bc.isUpgradable()
                                    ? Colors.green
                                    : Colors.red,
                                elevation: 0,
                              ),
                              onPressed: () {
                                bc.upgrade();
                                setState(() {});
                              },
                              child: const Text(
                                "Améliorer ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
