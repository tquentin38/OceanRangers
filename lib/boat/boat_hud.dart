import 'dart:async';

import 'package:challenge2024/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/game_file.dart';
import '../core/ressources/ressource.dart';
import '../core/restapi/communication.dart';

class BoatHUD extends StatefulWidget {
  const BoatHUD({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Ocean Ranger - Ship view";

  @override
  State<BoatHUD> createState() => _BoatHUDState();
}

class _BoatHUDState extends State<BoatHUD> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle titleSize = const TextStyle(fontSize: 25);
  TextStyle normalSize = const TextStyle(fontSize: 15);
  @override
  void initState() {
    super.initState();
    if (GameFile().nextRobotAvaiable.isAfter(DateTime.now())) {
      Timer.periodic(const Duration(milliseconds: 150), (Timer t) {
        if (GameFile().nextRobotAvaiable.isAfter(DateTime.now())) {
          if (mounted) setState(() {});
        } else {
          if (mounted) setState(() {});
          t.cancel();
        }

        if (!mounted) t.cancel();
      });
    }
    //update HUD for ressources usage
    Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      if (mounted) setState(() {});
      if (!mounted) t.cancel();
    });
    Timer(const Duration(milliseconds: 500), () {
      if (!GameFile().isIntroPassed) {
        showDialog(context: context, builder: showQuickHelp);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.normal,
      fontSize: 15,
      decoration: TextDecoration.none);

  double getMaxHeight() {
    double h = MediaQuery.of(context).size.height / 15;
    if (h > 40) {
      h = 40;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        SizedBox(
          height: getMaxHeight(),
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint(ModalRoute.of(context)?.settings.name);
                      if (ModalRoute.of(context)?.settings.name != "/boat") {
                        Navigator.pushReplacementNamed(context, "/boat");
                      }
                    },
                    child: const Icon(Icons.home),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showUserInfos);
                    },
                    child: const Icon(Icons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showQuickPage);
                    },
                    child: const Icon(Icons.folder_copy_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showQuickHelp);
                    },
                    child: const Icon(Icons.info),
                  ),
                ),
                if (GameFile().nextRobotAvaiable.isBefore(DateTime.now()))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
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
                          "Start exploring",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Repairing (${GameFile().nextRobotAvaiable.difference(DateTime.now()).inSeconds}s)",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Expanded(
                  child: FittedBox(child: Text("Ressources", style: textStyle)),
                ),
                for (Ressource ressource
                    in GameFile().ressourcesManager.ressources)
                  Expanded(
                      child: FittedBox(
                    child: Text(
                      "${ressource.getName()}:${ressource.value}",
                      style: textStyle,
                    ),
                  ))
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget showQuickHelp(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "Starting help",
                style: titleSize,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Welcome to Ocean Rangers !\nYou goal here is to help us clean the ocean and make reseach on what the \ndeepst layer of the ocean look like. You are our robot pilot, so your job is to pilot our submarine robot.\nIt is in rough condition, but if you find material, we will be able to mae some upgrade to it !",
                    textAlign: TextAlign.center),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "To naviguate on the boat, you can click on the icons: "),
                  ),
                  Icon(
                    Icons.crisis_alert,
                    size: 20,
                    color: Color.fromARGB(255, 185, 0, 0),
                    weight: 150,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Also you can discuss with the people on board. "),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "You can go to the ocean in all menus with the 'Start exploring' button."),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "In the ocean, you can collect trash that will be transformed into ressources\nSo more exploring mean more upgrade and more ressources etc...",
                  textAlign: TextAlign.justify,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Remember, the deepest you go, the more resources you will get.\n Also, the upgrade will help you, so don't hesitate to use your ressources !",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                  ),
                  onPressed: () {
                    GameFile().setIntroPassed();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 120, 167, 253),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => const LicensePage(
                        applicationName: "ProjectOcean",
                        applicationVersion: "1.0",
                        applicationLegalese:
                            "© www.freepik.com assets\n©Juliette Chappaz & Thibaut Quentin",
                      ),
                    ));
                  },
                  child: const Text(
                    "Show licences",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showQuickPage(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "Quick access",
                style: titleSize,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/ong");
                  },
                  child: const Text(
                    "Teams",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/elec");
                  },
                  child: const Text(
                    "Electronic room",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/machine");
                  },
                  child: const Text(
                    "Machine room",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/staff");
                  },
                  child: const Text(
                    "Staff room",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/marina");
                  },
                  child: const Text(
                    "Marina",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/wheel");
                  },
                  child: const Text(
                    "Wheel houses",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showUserInfos(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            Expanded(
              child: Text(
                "User profile",
                style: titleSize,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Username : ${GameFile().pseudo}",
                    style: titleSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 0,
                      ),
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.pop(context);
                        showDialog(context: context, builder: showPseudoChange);
                      },
                      child: const Text(
                        "Change",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  /*Text(
                    "Google wallet card",
                    style: titleSize,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () async {
                          //Navigator.pop(context);
                          //Navigator.pop(context);
                          //showDialog(context: context, builder: showPseudoChange);
                          if (GameFile().token != null) {
                            updateWallet();
                            final Uri url = Uri.parse(
                                "https://pay.google.com/gp/v/save/${GameFile().token}");
                            launchUrl(url);
                          }
                        },
                        child: const Image(
                            image: AssetImage("assets/images/add_wallet.png"))),
                  )
                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        //Navigator.pop(context);
                        //Navigator.pop(context);
                        //showDialog(context: context, builder: showPseudoChange);
                        if (GameFile().token != null) {
                          updateWallet();
                          final Uri url = Uri.parse(
                              "https://pay.google.com/gp/v/save/${GameFile().token}");
                          launchUrl(url);
                        }
                      },
                      child: const Text(
                        "Get my card",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: Padding(
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
                    "Close profile",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String newPseudo = "";
  Widget showPseudoChange(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Expanded(
              child: Text(
                "Edit username",
                style: titleSize,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'What do people call you?',
                      labelText: 'pseudo *',
                    ),
                    initialValue: GameFile().pseudo,
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    onChanged: (value) => {newPseudo = value},
                  ),
                  const Text(
                      "Please note thaht this can be shown to other player !"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 0,
                      ),
                      onPressed: () {
                        GameFile().changePseudo(newPseudo);
                        Navigator.pop(context);
                        showDialog(context: context, builder: showUserInfos);
                      },
                      child: const Text(
                        "Change",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(context: context, builder: showUserInfos);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
