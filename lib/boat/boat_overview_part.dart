import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
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
                image: AssetImage("assets/images/external_ship_2.jpg"),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: height,
            width: width,
          ),
          Positioned(
              top: height / 3 + height / 12 - 50,
              left: width - (width / 2.5 + width / 12 + 50),
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height / 9 + height / 8 - 50,
              left: width - (width / 6 + width / 8 + 50),
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height - (height / 3.25 + height / 12 + 50),
              left: width / 4.5 + width / 12 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height - (height / 6 + height / 12 + 50),
              left: width / 10 + width / 12 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: 0 + height / 5 - 50,
              left: 0 + width / 8 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height - (50 + width * 0.15),
              left: width - (50 + width * 0.15 * 200 / 178),
              height: width * 0.15,
              width: width * 0.15 * 200 / 178,
              child: GestureDetector(
                onTap: () {
                  if (GameFile()
                          .nextRobotAvaiable
                          .difference(DateTime.now())
                          .inSeconds <=
                      0) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => GameOceanWidget()),
                    );
                  }
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
              height: height / 4,
              width: width / 4,
              top: height / 9,
              left: width - (width / 6 + width / 4),
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
              height: height / 6,
              width: width / 6,
              top: height / 3,
              left: width - (width / 2.5 + width / 6),
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
              height: height / 6,
              width: width / 6,
              top: height - height / 3.25 - height / 6,
              left: width / 4.5,
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
              height: height / 6,
              width: width / 6,
              top: height - height / 3,
              left: width / 10,
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
              height: height / 2.5,
              width: width / 4,
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
        ]),
      ),
    );
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
