import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/building/building_caracteristic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';

class BoatBatimentPage extends StatefulWidget {
  const BoatBatimentPage({super.key});

  @override
  State<BoatBatimentPage> createState() => _BoatBatimentPageState();
}

class _BoatBatimentPageState extends State<BoatBatimentPage> {
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
          Positioned(
            bottom: height * 0.1,
            left: width * 0.05,
            height: height * 0.6,
            width: width * 0.9,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(175, 211, 211, 211)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        "Boat upgrade  (${GameFile().building.buildingCaracteristics.length} available)",
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
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (BuildingCaracteritic bc
                            in GameFile().building.buildingCaracteristics)
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
                                          bc.getName(),
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration: TextDecoration.none),
                                        ),
                                        Text(
                                            "${bc.getLevel()}/${bc.getLevelMax()} upgrade",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.none)),
                                        Text(bc.getDescription(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.none)),
                                        Text(bc.getNeededForUpgrade(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.none)),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: bc.isUpgradable()
                                                ? Colors.green
                                                : Colors.red,
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            bc.upgrade();
                                            setState(() {});
                                          },
                                          child: const Text("Purchase upgrade",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none)),
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
                    {Navigator.pushReplacementNamed(context, "/boat/machine")},
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
    );
  }
}
