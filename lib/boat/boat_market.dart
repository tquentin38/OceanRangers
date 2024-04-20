import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/ressources/ressource.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';
import '../core/restapi/communication.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool seenIntro = GameFile().seenIntro;
  bool showBoatDialog = false;
  List<Alliance> alliances = [];
  TextStyle titleSize = const TextStyle(
      fontSize: 25, color: Colors.black, decoration: TextDecoration.none);
  TextStyle normalSize = const TextStyle(
    fontSize: 15,
    color: Colors.black,
    decoration: TextDecoration.none,
  );
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  BoatDialog? boatDialog;

  bool fromW = false;
  bool fromP = false;
  bool fromI = false;
  bool toW = false;
  bool toP = false;
  bool toI = false;

  int selectedFrom = -1;
  int selectedTo = -1;
  double selectedValue = 0;

  String getName(int id) {
    id++;
    for (RessourcesTypes ressourcesTypes in RessourcesTypes.values) {
      if (ressourcesTypes.identifier == id) {
        return ressourcesTypes.name;
      }
    }
    return "";
  }

  RessourcesTypes getRessourcesType(int id) {
    id++;
    for (RessourcesTypes ressourcesTypes in RessourcesTypes.values) {
      if (ressourcesTypes.identifier == id) {
        return ressourcesTypes;
      }
    }
    return RessourcesTypes.iron;
  }

  void setRessource(int id, bool from, bool newVal) {
    if (from) {
      if (newVal) {
        selectedFrom = id;
      } else {
        selectedFrom = -1;
      }
    } else {
      if (newVal) {
        selectedTo = id;
      } else {
        selectedTo = -1;
      }
    }
    selectedValue = 0;
    setState(() {});
  }

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
                  image: AssetImage("assets/images/vieux_port_marseille.png"),
                  fit: BoxFit.fill,
                )),
            SizedBox(
                height: height,
                width: width,
                child: Padding(
                  padding: EdgeInsets.only(top: getMaxHeight(context)),
                  child: const Image(
                    image: AssetImage("assets/images/alliance_board.png"),
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              height: height * 0.8,
              width: width * 0.965,
              child: Padding(
                padding: EdgeInsets.only(
                    top: getMaxHeight(context) * 2.5,
                    left: width * 0.035,
                    bottom: getMaxHeight(context) * 0.9),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(0, 218, 218, 218)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        appBar: AppBar(
                          backgroundColor:
                              const Color.fromARGB(137, 173, 173, 173),
                          title: const Text("Market"),
                          centerTitle: true,
                          primary: false,
                          automaticallyImplyLeading: false,
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Column(
                                        children: [
                                          const Text(
                                              "Choose a ressource to trade"),
                                          Row(
                                            children: [
                                              const Text("Wood"),
                                              Checkbox(
                                                  value: selectedFrom == 0,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        0, true, newValue!);
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Plastic"),
                                              Checkbox(
                                                  value: selectedFrom == 1,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        1, true, newValue!);
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Iron"),
                                              Checkbox(
                                                  value: selectedFrom == 2,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        2, true, newValue!);
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Column(
                                        children: [
                                          const Text(
                                              "Choose a ressource to receive"),
                                          Row(
                                            children: [
                                              const Text("Wood"),
                                              Checkbox(
                                                  value: selectedTo == 0,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        0, false, newValue!);
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Plastic"),
                                              Checkbox(
                                                  value: selectedTo == 1,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        1, false, newValue!);
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Iron"),
                                              Checkbox(
                                                  value: selectedTo == 2,
                                                  onChanged: (newValue) {
                                                    setRessource(
                                                        2, false, newValue!);
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (selectedFrom == -1)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select a ressource to exchange !',
                                    style: normalSize,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              else if (selectedTo == -1)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select a ressource te receive',
                                    style: normalSize,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              else if (selectedFrom == selectedTo)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'You cannot exchange the same ressources !',
                                    style: normalSize,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Current exchange rate : 0.75',
                                        style: normalSize,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${getName(selectedFrom)} => ${getName(selectedTo)}',
                                        style: normalSize,
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 100, maxWidth: 300),
                                        child: Slider(
                                            value: selectedValue,
                                            min: 0,
                                            max: GameFile()
                                                .ressourcesManager
                                                .get(getRessourcesType(
                                                    selectedFrom))
                                                .toDouble(),
                                            divisions: 100,
                                            onChanged: (newValue) {
                                              //debugPrint("newval : $newValue");
                                              selectedValue =
                                                  newValue.roundToDouble();

                                              setState(() {});
                                            }),
                                      ),
                                      Text(
                                          "$selectedValue ${getName(selectedFrom)} => ${(selectedValue * 0.75).roundToDouble()} ${getName(selectedTo)}"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            if (GameFile()
                                                .ressourcesManager
                                                .has(
                                                    getRessourcesType(
                                                        selectedFrom),
                                                    selectedValue.round())) {
                                              GameFile()
                                                  .ressourcesManager
                                                  .consume(
                                                      getRessourcesType(
                                                          selectedFrom),
                                                      selectedValue.round());
                                              GameFile().ressourcesManager.add(
                                                  getRessourcesType(selectedTo),
                                                  (selectedValue * 0.75)
                                                      .round());
                                            }
                                            selectedValue = 0;
                                            setState(() {});
                                          },
                                          child: const Text(
                                            "Trade",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: height / 20 + height / 20 - 25,
                left: 0 + width / 20 - 25,
                child: const Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Color.fromARGB(255, 185, 0, 0),
                  weight: 150,
                )),
            Positioned(
                height: height / 10,
                width: width / 10,
                top: height / 20,
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
            const BoatHUD(),
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
      ),
    );
  }

  Widget showStats(BuildContext context) {
    double height = getMaxedSize(context).y;
    return AlertDialog(
      content: SizedBox(
        height: height / 1.5,
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
