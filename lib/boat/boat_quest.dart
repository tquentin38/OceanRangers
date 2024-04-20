import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/quests/quests_manager.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';
import '../core/restapi/communication.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({super.key});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
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
  @override
  void initState() {
    GameFile().questsManager.updateQuests();
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
                child: Padding(
                  padding: EdgeInsets.only(top: getMaxHeight(context)),
                  child: const Image(
                    image: AssetImage("assets/images/world_map.jpg"),
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
                              const Color.fromARGB(220, 173, 173, 173),
                          title: const Text("Quests"),
                          centerTitle: true,
                          primary: false,
                          automaticallyImplyLeading: false,
                          bottom: TabBar(
                            onTap: (value) {
                              setState(() {});
                            },
                            tabs: const [
                              Tab(
                                text: "Open quest",
                              ),
                              Tab(
                                text: "Completed",
                              ),
                            ],
                          ),
                        ),
                        body: TabBarView(children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Open quests',
                                    style: titleSize,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(210, 218, 218, 218),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      children: [
                                        TableRow(children: [
                                          Text(
                                            'Name',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Description',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Objective',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Avancement',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                        ]),
                                        for (QuestHolder questHolder
                                            in GameFile()
                                                .questsManager
                                                .getQuests(false))
                                          TableRow(children: [
                                            Text(
                                              questHolder.quest.name,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              questHolder.quest.description,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              questHolder.quest.objective,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "${questHolder.value.toInt()}/${questHolder.quest.value}",
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                          ])
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Quest completed',
                                    style: titleSize,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(210, 218, 218, 218),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      children: [
                                        TableRow(children: [
                                          Text(
                                            'Name',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Description',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Time completed',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                        ]),
                                        for (QuestHolder questHolder
                                            in GameFile()
                                                .questsManager
                                                .getQuests(true))
                                          TableRow(children: [
                                            Text(
                                              questHolder.quest.name,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              questHolder.quest.description,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              questHolder.quest.objective,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                          ])
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
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
                      {Navigator.pushReplacementNamed(context, "/boat/staff")},
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
