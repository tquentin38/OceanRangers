import 'dart:async';

import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
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
    double width = getMaxedSize(context).x;
    double height = getMaxedSize(context).y;
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(
            left: getPaddingSide(context),
            right: getPaddingSide(context),
            top: getPaddingVertical(context),
            bottom: getPaddingVertical(context)),
        child: Stack(children: [
          SizedBox(
              height: height,
              width: width,
              child: const Image(
                image: AssetImage("assets/images/commanderie.jpg"),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: height,
            width: width,
          ),
          const BoatHUD(),
          Positioned(
              top: height / 2 + height / 8 - 50,
              left: width - (width / 2.5 + width / 6 + 50),
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height / 3 + height / 8 - 50,
              left: 0 + width / 12 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 4,
              width: width / 3,
              top: height / 2,
              right: width / 2.5,
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
              height: height / 1.8,
              width: width / 3,
              left: height / 30,
              top: height - (height / 1.8),
              child: GestureDetector(
                onTap: () {
                  if (showBoatDialog) {
                    boatDialog = null;
                    showBoatDialog = false;
                  } else {
                    boatDialog = BoatDialog(
                        dialogHolder: GameFile()
                            .peopleManager
                            .getDialog(PeopleDialog.commandante));
                    showBoatDialog = true;

                    Timer.periodic(const Duration(milliseconds: 100),
                        (Timer t) {
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
              height: height / 2,
              width: width / 3,
              left: width - (height / 10 + width / 3),
              top: height - (height / 2),
              child: GestureDetector(
                onTap: () {
                  if (showBoatDialog) {
                    boatDialog = null;
                    showBoatDialog = false;
                  } else {
                    boatDialog = BoatDialog(
                        dialogHolder: GameFile()
                            .peopleManager
                            .getDialog(PeopleDialog.second));
                    showBoatDialog = true;

                    Timer.periodic(const Duration(milliseconds: 100),
                        (Timer t) {
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
              height: height / 4,
              width: width / 6,
              top: height / 3,
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
              top: mouseY + 10 - getPaddingVertical(context),
              left: mouseX + 10 - getPaddingSide(context),
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
        ]),
      ),
    );
  }

  Widget showStats(BuildContext context) {
    double height = getMaxedSize(context).y;
    return AlertDialog(
      content: SizedBox(
        height: height / 3,
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
