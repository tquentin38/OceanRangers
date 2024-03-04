import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/core/robot/robot_caracterisitc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class BoatRobotPage extends StatefulWidget {
  const BoatRobotPage({super.key});

  @override
  State<BoatRobotPage> createState() => _BoatRobotPageState();
}

class _BoatRobotPageState extends State<BoatRobotPage> {
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
            image: AssetImage("assets/images/manip_room.jpg"),
            fit: BoxFit.fill,
          )),
      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.1,
        left: MediaQuery.of(context).size.width * 0.05,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(175, 211, 211, 211)),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Robots",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        decoration: TextDecoration.none)),
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (RobotCaracteritic rc
                        in GameFile().robot.robotCaracteristics)
                      SingleChildScrollView(
                        child: Padding(
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          decoration: TextDecoration.none),
                                    ),
                                    Text(
                                      "${rc.getLevel()}/${rc.getLevelMax()} upgrade",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.none),
                                    ),
                                    Text(rc.getDescription(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15,
                                            decoration: TextDecoration.none)),
                                    Text(rc.getNeededForUpgrade(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            decoration: TextDecoration.none)),
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
                                        "Purchase upgrade",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            onTap: () =>
                {Navigator.pushReplacementNamed(context, "/boat/elec")},
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
      const BoatHUD(),
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
