import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class BoatOverview extends StatefulWidget {
  const BoatOverview({super.key});

  @override
  State<BoatOverview> createState() => _BoatOverviewState();
}

class _BoatOverviewState extends State<BoatOverview> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle dialogStyle = const TextStyle(fontSize: 25);
  bool isHover = false;
  TextStyle titleSize = const TextStyle(fontSize: 25);
  TextStyle normalSize = const TextStyle(fontSize: 15);
  String hoverValue = "Error: no hover !";
  bool isHoverOcean = false;

  @override
  void initState() {
    GameFile().getAudioPlayer().stop();
    Future.delayed(const Duration(milliseconds: 500), () {
      GameFile().getAudioPlayer().play(
          AssetSource('audio/seagulls_short-6004.mp3'),
          volume: GameFile().audioVolume / 100);
      setState(() {});
    });
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
            image: AssetImage("assets/images/external_ship_2.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      Positioned(
          top: MediaQuery.of(context).size.height / 3 +
              MediaQuery.of(context).size.height / 12 -
              50,
          right: MediaQuery.of(context).size.width / 2.5 +
              MediaQuery.of(context).size.width / 12 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          top: MediaQuery.of(context).size.height / 9 +
              MediaQuery.of(context).size.height / 8 -
              50,
          right: MediaQuery.of(context).size.width / 6 +
              MediaQuery.of(context).size.width / 8 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          bottom: MediaQuery.of(context).size.height / 3.25 +
              MediaQuery.of(context).size.height / 12 -
              50,
          left: MediaQuery.of(context).size.width / 4.5 +
              MediaQuery.of(context).size.width / 12 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          bottom: MediaQuery.of(context).size.height / 6 +
              MediaQuery.of(context).size.height / 12 -
              50,
          left: MediaQuery.of(context).size.width / 10 +
              MediaQuery.of(context).size.width / 12 -
              50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          top: 0 + MediaQuery.of(context).size.height / 5 - 50,
          left: 0 + MediaQuery.of(context).size.width / 8 - 50,
          child: const Icon(
            Icons.crisis_alert,
            size: 100,
            color: Color.fromARGB(255, 185, 0, 0),
            weight: 150,
          )),
      Positioned(
          bottom: 0 + 50,
          right: 0 + 50,
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.15 * 200 / 178,
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => GameOceanWidget()),
              );
            },
            child: Column(
              children: [
                if (GameFile().nextRobotAvaiable.isBefore(DateTime.now()))
                  MouseRegion(
                    hitTestBehavior: HitTestBehavior.opaque,
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      isHover = true;
                      hoverValue = "Go to the Ocean";
                    },
                    onExit: (event) {
                      isHover = false;
                      setState(() {});
                    },
                    onHover: _updatelocation,
                    child: const Image(
                      image: AssetImage("assets/images/sous_marin.png"),
                      fit: BoxFit.fill,
                    ),
                  )
                else
                  MouseRegion(
                    hitTestBehavior: HitTestBehavior.opaque,
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      isHover = true;
                      isHoverOcean = true;
                      hoverValue =
                          "Repairing (${GameFile().nextRobotAvaiable.difference(DateTime.now()).inSeconds}s)";
                      setState(() {});

                      Timer.periodic(const Duration(seconds: 1), (timer) {
                        if (isHoverOcean) {
                          hoverValue =
                              "Repairing (${GameFile().nextRobotAvaiable.difference(DateTime.now()).inSeconds}s)";
                        }
                        if (mounted) {
                          setState(() {});
                        } else {
                          timer.cancel();
                        }
                        if (GameFile()
                                .nextRobotAvaiable
                                .difference(DateTime.now())
                                .inSeconds <=
                            0) {
                          if (isHoverOcean) {
                            hoverValue = "Go to the Ocean";
                          }
                          if (GameFile()
                                  .nextRobotAvaiable
                                  .difference(DateTime.now())
                                  .inSeconds <=
                              -5) timer.cancel();
                        }
                      });
                    },
                    onExit: (event) {
                      isHover = false;
                      isHoverOcean = false;
                      setState(() {});
                    },
                    onHover: _updatelocation,
                    child: const Image(
                      image: AssetImage("assets/images/sous_marin.png"),
                      fit: BoxFit.fill,
                      color: Color.fromARGB(186, 156, 156, 156),
                    ),
                  ),
              ],
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
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          top: MediaQuery.of(context).size.height / 9,
          right: MediaQuery.of(context).size.width / 6,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/wheel")},
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to the Wheelhouses";
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
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 6,
          top: MediaQuery.of(context).size.height / 3,
          right: MediaQuery.of(context).size.width / 2.5,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/staff")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to the Staff house";
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
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 6,
          bottom: MediaQuery.of(context).size.height / 3.25,
          left: MediaQuery.of(context).size.width / 4.5,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/elec")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to the electronic room";
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
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 6,
          bottom: MediaQuery.of(context).size.height / 6,
          left: MediaQuery.of(context).size.width / 10,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/machine")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to the machine room";
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
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width / 4,
          top: 0,
          left: 0,
          child: GestureDetector(
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/marina")},
            child: MouseRegion(
              //child: Container(decoration: BoxDecoration(color: Colors.black)),
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                isHover = true;
                hoverValue = "Go to the marina";
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
    ]);
  }

  Widget showStartOcean(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Text(
              "Go to the ocean",
              style: titleSize,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Go to Ocean !"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (GameFile().nextRobotAvaiable.isBefore(DateTime.now()))
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => GameOceanWidget()),
                          );
                        },
                        child: const Text(
                          "Start Ocean",
                          style: TextStyle(color: Colors.white),
                        ))
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Repairing (${GameFile().nextRobotAvaiable.difference(DateTime.now()).inSeconds}s)",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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

  Widget showStartOceanOld(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Text(
              "Go to the ocean",
              style: titleSize,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Go to Ocean !"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (GameFile().nextRobotAvaiable.isBefore(DateTime.now()))
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => GameOceanWidget()),
                          );
                        },
                        child: const Text(
                          "Start Ocean",
                          style: TextStyle(color: Colors.white),
                        ))
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Repairing (${GameFile().nextRobotAvaiable.difference(DateTime.now()).inSeconds}s)",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
