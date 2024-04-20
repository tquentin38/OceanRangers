import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/game_file.dart';
import '../core/restapi/communication.dart';

class AlliancePage extends StatefulWidget {
  const AlliancePage({super.key});

  @override
  State<AlliancePage> createState() => _AlliancePageState();
}

class _AlliancePageState extends State<AlliancePage> {
  bool seenIntro = GameFile().seenIntro;
  bool showBoatDialog = false;
  List<Alliance> alliances = [];
  TextStyle titleSize = const TextStyle(
      fontSize: 15, color: Colors.black, decoration: TextDecoration.none);
  TextStyle normalSize = const TextStyle(
    fontSize: 10,
    color: Colors.black,
    decoration: TextDecoration.none,
  );
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  BoatDialog? boatDialog;
  @override
  void initState() {
    super.initState();
    loadAlliances();
  }

  void loadAlliances() async {
    await getCurrentAlliance();
    alliances = await getAllianceWeb();
    setState(() {});
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
              height: height * 0.85,
              width: width * 0.965,
              child: Padding(
                padding: EdgeInsets.only(
                    top: getMaxHeight(context) * 2,
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
                          title: const Text("Teams"),
                          centerTitle: true,
                          primary: false,
                          automaticallyImplyLeading: false,
                          bottom: TabBar(
                            onTap: (value) {
                              setState(() {});
                            },
                            tabs: const [
                              Tab(
                                text: "My team",
                              ),
                              Tab(
                                text: "Leaderboard",
                              ),
                            ],
                          ),
                        ),
                        body: TabBarView(children: [
                          if (GameFile().idAlliance == -1)
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'You are not member of a team !',
                                        style: titleSize,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'You can join one on the leadarbord !',
                                      style: titleSize,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Your team : ${GameFile().allianceName} ',
                                      style: titleSize,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Member since ${GameFile().allianceJoinedDate} (CEST)',
                                      style: titleSize,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        elevation: 0,
                                      ),
                                      onPressed: () async {
                                        await leaveAlliance();
                                        setState(() {});
                                      },
                                      child: const Text(
                                        "Leave team",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                                    'Leaderboard',
                                    style: titleSize,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(150, 218, 218, 218),
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
                                            'Trash collected',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Descritpion',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Members',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Join',
                                            style: normalSize,
                                            textAlign: TextAlign.center,
                                          ),
                                        ]),
                                        for (Alliance al in alliances)
                                          TableRow(children: [
                                            Text(
                                              al.name,
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "${al.trashPoints}",
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            MouseRegion(
                                              onEnter: (event) {
                                                al.isHover = true;
                                                setState(() {});
                                              },
                                              onExit: (event) {
                                                al.isHover = false;
                                                setState(() {});
                                              },
                                              child: Column(
                                                children: [
                                                  if (!al.isHover)
                                                    Text(
                                                      al.description,
                                                      style: normalSize,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  else
                                                    Text(
                                                      al.longDescription,
                                                      style: normalSize,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${al.numberOfMember}",
                                              style: normalSize,
                                              textAlign: TextAlign.center,
                                            ),
                                            if (GameFile().idAlliance != al.id)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 20,
                                                    right: 20),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    elevation: 0,
                                                  ),
                                                  onPressed: () async {
                                                    if (await joinAlliance(
                                                        al.id)) {
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "You joined ${al.name} !"),
                                                        ));
                                                      }

                                                      alliances =
                                                          await getAllianceWeb();
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Join",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              )
                                            else
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 20,
                                                    right: 20),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    elevation: 0,
                                                  ),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Joined",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              )
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
