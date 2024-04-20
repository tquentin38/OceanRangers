import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
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
    double width = getMaxedSize(context).x;
    double height = getMaxedSize(context).y;
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.height,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 230, 230, 230)),
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
            Positioned(
              bottom: height * 0.025,
              left: width * 0.025,
              height: height * 0.775,
              width: width * 0.95,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(175, 211, 211, 211)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "Robot upgrades (${GameFile().robot.robotCaracteristics.length} available)",
                          style: const TextStyle(
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
                        mainAxisSpacing: 1,
                        crossAxisCount: 3,
                        children: <Widget>[
                          for (RobotCaracteritic rc
                              in GameFile().robot.robotCaracteristics)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(), color: Colors.grey),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            rc.getName(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(
                                            "${rc.getLevel()}/${rc.getLevelMax()} upgrade",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(rc.getDescription(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  decoration:
                                                      TextDecoration.none)),
                                          Text(rc.getNeededForUpgrade(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  decoration:
                                                      TextDecoration.none)),
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
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            const BoatHUD(),
            if (showBoatDialog) boatDialog!,
          ]),
        ),
      ),
    );
  }
}
