import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
import 'package:ocean_rangers/core/ressources/ressource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/game_file.dart';
import '../core/restapi/communication.dart';

class ONGPage extends StatefulWidget {
  const ONGPage({super.key});

  @override
  State<ONGPage> createState() => _ONGPageState();
}

class _ONGPageState extends State<ONGPage> {
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
                          backgroundColor:
                              const Color.fromARGB(0, 255, 255, 255),
                          appBar: AppBar(
                            backgroundColor:
                                const Color.fromARGB(137, 173, 173, 173),
                            title: const Text("Non-governmental organization"),
                            centerTitle: true,
                            primary: false,
                            automaticallyImplyLeading: false,
                          ),
                          body: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(4),
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              crossAxisCount: 3,
                              children: <Widget>[
                                for (ONG ong in ONG.values)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: Colors.grey),
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  ong.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.black,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                Text(
                                                  ong.desc,
                                                  textAlign: TextAlign.justify,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    elevation: 0,
                                                  ),
                                                  onPressed: () {
                                                    final Uri url =
                                                        Uri.parse(ong.url);
                                                    launchUrl(url);
                                                  },
                                                  child: const Text(
                                                    "Learn more",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                              ])),
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
}

enum ONG implements Comparable<ONG> {
  globalcitizen(
      identifier: 1,
      name: "Global Citizen",
      url: "https://www.globalcitizen.org/",
      desc:
          "Global Citizen, also known as Global Poverty Project, is an international education and advocacy organization that seeks to catalyze the movement to end extreme poverty and promote social justice and equity through the lens of intersectionality."),
  unep(
      identifier: 1,
      name: "United Nations Environment Programme",
      url: "https://www.unep.org/",
      desc:
          "The United Nations Environment Programme (UNEP) is the leading global authority on the environment. UNEP’s mission is to inspire, inform, and enable nations and peoples to improve their quality of life without compromising that of future generations."),
  ;

  const ONG(
      {required this.identifier,
      required this.name,
      required this.url,
      required this.desc});

  final int identifier;
  final String name;
  final String url;
  final String desc;

  @override
  int compareTo(ONG other) => identifier - other.identifier;
}
