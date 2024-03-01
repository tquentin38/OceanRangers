import 'dart:async';

import 'package:challenge2024/boat/boat_dialog.dart';
import 'package:challenge2024/boat/boat_hud.dart';
import 'package:challenge2024/core/people/people_manager.dart';
import 'package:challenge2024/core/robot/robot_caracterisitc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class BoatTech extends StatefulWidget {
  const BoatTech({super.key});

  @override
  State<BoatTech> createState() => _BoatTechState();
}

class _BoatTechState extends State<BoatTech> {
  bool seenIntro = GameFile().seenIntro;
  bool showBoatDialog = false;
  TextStyle titleSize = TextStyle(fontSize: 25);
  TextStyle normalSize = TextStyle(fontSize: 15);
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage("assets/images/manip_room.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      const BoatHUD(),
      Positioned(
          bottom: 0 + MediaQuery.of(context).size.height / 6 - 50,
          right: MediaQuery.of(context).size.width / 8 +
              MediaQuery.of(context).size.width / 4 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 3.5,
          left: MediaQuery.of(context).size.height / 15,
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
                        .getDialog(PeopleDialog.techguy));
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
                  image: AssetImage("assets/images/techguy.png"),
                  fit: BoxFit.fill,
                )),
          )),
      Positioned(
          top: MediaQuery.of(context).size.height / 20 +
              MediaQuery.of(context).size.height / 8 -
              50,
          left: MediaQuery.of(context).size.width / 15 +
              MediaQuery.of(context).size.width / 8 -
              50,
          child: const Icon(
            Icons.arrow_back,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          top: MediaQuery.of(context).size.height / 20,
          left: MediaQuery.of(context).size.width / 15,
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
          width: MediaQuery.of(context).size.width / 2,
          bottom: 0,
          right: MediaQuery.of(context).size.width / 8,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/elec/robot")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Robots updates";
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
                "Robots",
                style: titleSize,
              ),
              for (RobotCaracteritic rc in GameFile().robot.robotCaracteristics)
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
                              rc.getName(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${rc.getLevel()}/${rc.getLevelMax()} améliorations",
                            ),
                            Text(rc.getNeededForUpgrade()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: rc.isUpgradable()
                                    ? Colors.green
                                    : Colors.red,
                                elevation: 0,
                              ),
                              onPressed: () {
                                rc.upgrade();
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
