import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ocean_rangers/core/input/keyboard.dart';
import 'package:ocean_rangers/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/game_file.dart';
import '../core/ressources/ressource.dart';
import '../core/restapi/communication.dart';

class BoatHUD extends StatefulWidget {
  const BoatHUD({super.key});
  final String title = "Ocean Ranger - Ship view";

  @override
  State<BoatHUD> createState() => _BoatHUDState();
}

class _BoatHUDState extends State<BoatHUD> {
  String lastKey = "";
  bool seenIntro = GameFile().seenIntro;
  TextStyle titleSize = const TextStyle(fontSize: 20);
  TextStyle normalSize = const TextStyle(fontSize: 10);
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
      decoration: TextDecoration.none);

  double getMaxHeight() {
    double h = MediaQuery.of(context).size.height / 15;
    if (h > 40) {
      h = 40;
    } else if (h < 30) {
      h = 30;
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(4.0),
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
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showSetting);
                    },
                    child: const Icon(Icons.settings),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showUserInfos);
                    },
                    child: const Icon(Icons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showQuickPage);
                    },
                    child: const Icon(Icons.folder_copy_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: showQuickHelp);
                    },
                    child: const Icon(Icons.info),
                  ),
                ),
                if (GameFile().nextRobotAvaiable.isBefore(DateTime.now()))
                  Padding(
                    padding: const EdgeInsets.all(4.0),
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        for (Ressource ressource
                            in GameFile().ressourcesManager.ressources)
                          Expanded(
                              child: FittedBox(
                            child: Text(
                              "${ressource.getName()}:${ressource.value}/${GameFile().boatContainerSize}",
                              style: textStyle,
                            ),
                          ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  int nextUpdate = 0;
  double audioValue = 0;
  Widget showSetting(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) mySetState) {
      audioValue = GameFile().audioVolume;
      bool onKey(KeyEvent event) {
        final key = event.logicalKey.keyLabel;
        lastKey = key;
        if (event is KeyUpEvent) {
          return false;
        } else if (event is KeyRepeatEvent) {
          return false;
        }
        if (nextUpdate != 0) {
          for (KeyCaracteritics keyCaracteritics in KeyCaracteritics.values) {
            if (nextUpdate == keyCaracteritics.identifier) {
              KeyCaracteritic? keyCaracteritic = GameFile()
                  .keyboardManager
                  .getCaracteristicFromEnum(keyCaracteritics);
              if (keyCaracteritic != null) {
                keyCaracteritic.setValue(key);
              }
            }
          }
          nextUpdate = 0;
        }
        if (context.mounted) {
          mySetState(() {});
        } else {
          ServicesBinding.instance.keyboard.removeHandler(onKey);
        }
        return false;
      }

      ServicesBinding.instance.keyboard.addHandler(onKey);

      return AlertDialog(
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            children: [
              Expanded(
                child: Text(
                  "Settings",
                  style: titleSize,
                ),
              ),
              Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Audio ${audioValue.toInt()}%"),
                        Slider(
                            value: audioValue,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (newValue) {
                              //debugPrint("newval : $newValue");
                              audioValue = newValue;
                              GameFile().setAudioVolume(newValue);
                              mySetState(() {});
                            }),
                        const Text("Keys"),
                        for (KeyCaracteritic key
                            in GameFile().keyboardManager.keyCaracteristics)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${key.getDescription()} ${key.value}"),
                              if (nextUpdate != key.type.identifier)
                                GestureDetector(
                                  onTap: () {
                                    nextUpdate = key.type.identifier;
                                    mySetState(() {});
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.edit),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    nextUpdate = 0;

                                    mySetState(() {});
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.cancel),
                                  ),
                                )
                            ],
                          ),
                      ],
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                    ),
                    onPressed: () {
                      ServicesBinding.instance.keyboard.removeHandler(onKey);
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
    });
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
                    "Welcome to Ocean Rangers !\nYou goal here is to help us clean the ocean and make reseach on what the \ndeepst layer of the ocean look like. You are our robot pilot, so your job is to pilot our submarine robot.\nIt is in rough condition, but if you find material, we will be able to make some upgrade to it !",
                    textAlign: TextAlign.center),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "To naviguate on the boat, click on these icons: "),
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
                child: Text(
                    "Also you can discuss with the people on board. I have heard that they all want to talk with you, \nso don't hesitate to open the conversation! "),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "You can go to the ocean in all menus with the 'Start exploring' button."),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "In the ocean, you can collect trash that will be transformed into resources\nSo more exploring means more upgrades and more resources, etc...",
                  textAlign: TextAlign.justify,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Remember, the deepest you go, the more resources you will get.\n Also, the upgrades will help you, so don't hesitate to use your resources!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                        applicationName: "Ocean Rangers",
                        applicationVersion: "1.0",
                        applicationLegalese:
                            "© www.freepik.com assets\nIntro Music by Aleksey Chistilin from Pixabay\n©Juliette Chappaz & Thibaut Quentin",
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
        height: MediaQuery.of(context).size.height / 2.2,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "Quick access",
                style: titleSize,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/elec/robot");
                  },
                  child: const Text(
                    "Robot Upgrade",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, "/boat/machine/batiment");
                  },
                  child: const Text(
                    "Boat Upgrade",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/boat/market");
                  },
                  child: const Text(
                    "Market",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                    style: TextStyle(color: Colors.white),
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
    double height = MediaQuery.of(context).size.height / 1.2;
    double width = MediaQuery.of(context).size.width / 3;
    if (height > 400) {
      height = 400;
      if (width > 400) {
        width = 400;
      }
    }
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return AlertDialog(
        content: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "User profile",
                  style: titleSize,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          debugPrint("ON TAP LEFT");
                          if (GameFile().profileId > 0) {
                            GameFile().setNewProfilId(GameFile().profileId - 1);
                          } else {
                            GameFile().setNewProfilId(5);
                          }
                          setState(() => {});
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          size: 50,
                          color: Color.fromARGB(255, 109, 109, 109),
                          weight: 150,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 2.5)),
                          child: Image(
                            image: AssetImage(
                                "assets/images/perso${GameFile().profileId}.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (GameFile().profileId < 5) {
                            GameFile().setNewProfilId(GameFile().profileId + 1);
                          } else {
                            GameFile().setNewProfilId(0);
                          }
                          debugPrint("ON TAP RIGHT");
                          setState(() => {});
                        },
                        child: const Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Color.fromARGB(255, 109, 109, 109),
                          weight: 150,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      "Username : ${GameFile().pseudo}",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0,
                        ),
                        onPressed: () {
                          //Navigator.pop(context);
                          Navigator.pop(context);
                          showDialog(
                              context: context, builder: showPseudoChange);
                        },
                        child: const Text(
                          "Change",
                          style: TextStyle(color: Colors.white),
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
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                          onTap: () async {
                            await updateWallet();
                            final Uri url = Uri.parse(
                                "https://pay.google.com/gp/v/save/${GameFile().token}");
                            launchUrl(url);
                          },
                          child: const Image(
                              image:
                                  AssetImage("assets/images/add_wallet.png"))),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String newPseudo = "";
  Widget showPseudoChange(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1.2;
    if (height > 250) {
      height = 250;
    }
    return AlertDialog(
      content: SizedBox(
        height: height,
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
