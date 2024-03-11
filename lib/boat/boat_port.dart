import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class Port extends StatefulWidget {
  const Port({super.key});

  @override
  State<Port> createState() => _PortState();
}

class _PortState extends State<Port> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle dialogStyle = const TextStyle(fontSize: 25);
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  bool showBoatDialog = false;
  BoatDialog? boatDialog;

  @override
  void initState() {
    super.initState();

    GameFile().getAudioPlayer().play(AssetSource('audio/sound_people_ext.mp3'),
        volume: GameFile().audioVolume / 100 * 0.4);
  }

  @override
  void dispose() {
    GameFile().getAudioPlayer().stop();
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
            image: AssetImage("assets/images/marina.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
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
      Positioned(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          right: MediaQuery.of(context).size.height / 10,
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
                        .getDialog(PeopleDialog.voyager));
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
                  image: AssetImage("assets/images/passante.png"),
                  fit: BoxFit.fill,
                )),
          )),
      const BoatHUD(),
      Positioned(
          bottom: MediaQuery.of(context).size.height / 10 +
              MediaQuery.of(context).size.height / 8 -
              50,
          left: MediaQuery.of(context).size.width / 15 +
              MediaQuery.of(context).size.width / 6 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
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
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 3,
          bottom: MediaQuery.of(context).size.height / 10,
          left: MediaQuery.of(context).size.width / 15,
          child: GestureDetector(
            onTap: () => {Navigator.pushReplacementNamed(context, "/boat/ong")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Teams";
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
}
