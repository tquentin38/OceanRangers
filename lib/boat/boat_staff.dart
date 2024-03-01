import 'dart:async';

import 'package:challenge2024/boat/boat_dialog.dart';
import 'package:challenge2024/boat/boat_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class BoatStaff extends StatefulWidget {
  const BoatStaff({super.key});

  @override
  State<BoatStaff> createState() => _BoatStaffState();
}

class _BoatStaffState extends State<BoatStaff> {
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
            image: AssetImage("assets/images/staff_room.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      Positioned(
          top: MediaQuery.of(context).size.height / 4.5 +
              MediaQuery.of(context).size.height / 8 -
              50,
          left: MediaQuery.of(context).size.width / 5 +
              MediaQuery.of(context).size.width / 8 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          top: MediaQuery.of(context).size.height / 2.25 +
              MediaQuery.of(context).size.height / 8 -
              50,
          right: MediaQuery.of(context).size.width / 4.5 +
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
          top: MediaQuery.of(context).size.height / 4.5,
          left: MediaQuery.of(context).size.width / 5,
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
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          top: MediaQuery.of(context).size.height / 2.25,
          right: MediaQuery.of(context).size.width / 4.5,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/quest")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to quest";
                setState(() {});
              },
              onExit: (event) {
                isHover = false;
                setState(() {});
              },
              onHover: _updatelocation,
            ),
          )),
      const BoatHUD(),
      /*Positioned(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 3.5,
          left: MediaQuery.of(context).size.height / 20,
          bottom: MediaQuery.of(context).size.width / 20,
          child: GestureDetector(
            onTap: () {
              if (showBoatDialog) {
                boatDialog = null;
                showBoatDialog = false;
              } else {
                boatDialog = BoatDialog(dialogs: const [
                  "Oh bonjour, non non, je ne suis pas un robot ! "
                ]);
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
                  image: AssetImage("assets/images/woman_sitted.png"),
                  fit: BoxFit.fill,
                )),
          )),*/
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
}
