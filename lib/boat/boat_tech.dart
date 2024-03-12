import 'dart:async';

import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
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
                image: AssetImage("assets/images/manip_room.jpg"),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: height,
            width: width,
          ),
          const BoatHUD(),
          Positioned(
              top: height - (height / 6 + 50),
              left: width - (width / 8 + width / 4 + 50),
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 3,
              width: width / 3.5,
              left: height / 15,
              top: height - height / 3,
              child: GestureDetector(
                onTap: () {
                  if (showBoatDialog) {
                    boatDialog = null;
                    showBoatDialog = false;
                  } else {
                    boatDialog = BoatDialog(
                        dialogHolder: GameFile()
                            .peopleManager
                            .getDialog(PeopleDialog.techguy));
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
                      image: AssetImage("assets/images/techguy.png"),
                      fit: BoxFit.fill,
                    )),
              )),
          Positioned(
              top: height / 20 + height / 8 - 50,
              left: width / 15 + width / 8 - 50,
              child: const Icon(
                Icons.arrow_back,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 4,
              width: width / 4,
              top: height / 20,
              left: width / 15,
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
              width: width / 2,
              bottom: 0,
              right: width / 8,
              child: GestureDetector(
                onTap: () => {
                  Navigator.pushReplacementNamed(context, "/boat/elec/robot")
                },
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
        ]),
      ),
    );
  }
}
