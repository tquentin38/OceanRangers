import 'dart:async';

import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                image: AssetImage("assets/images/tech_room.jpg"),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: height,
            width: width,
          ),
          const BoatHUD(),
          Positioned(
              top: height / 8 + height / 6 - 50,
              left: 0 + width / 7 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 2,
              width: width / 4,
              left: width - (height / 20 + width / 4),
              top: height - height / 2,
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
                      image: AssetImage("assets/images/ouvier.png"),
                      fit: BoxFit.fill,
                    )),
              )),
          Positioned(
              top: height - (height / 8 + 50),
              left: width / 2.5 + width / 8 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 4,
              width: width / 4,
              top: height - height / 4,
              left: width / 2.5,
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
          Positioned(
              height: height / 3,
              width: width / 3.5,
              top: height / 8,
              left: 0,
              child: GestureDetector(
                onTap: () => {
                  Navigator.pushReplacementNamed(
                      context, "/boat/machine/batiment")
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
        ]),
      ),
    );
  }
}
