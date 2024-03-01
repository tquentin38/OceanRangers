import 'dart:async';

import 'package:challenge2024/core/building/building_caracteristic.dart';
import 'package:challenge2024/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/game_file.dart';
import 'core/ressources/ressource.dart';
import 'core/robot/robot_caracterisitc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class BoatPage extends StatefulWidget {
  const BoatPage({super.key});

  final String title = "Project Aqua - Ship view";

  @override
  State<BoatPage> createState() => _BoatPageState();
}

class _BoatPageState extends State<BoatPage> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle dialogStyle = TextStyle(fontSize: 25);
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: GestureDetector(
          child: Text(widget.title),
          onTap: () {
            Navigator.pushReplacementNamed(context, "/boat");
            /*Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => const BoatOverview()),
            );*/
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: Text("Ressources")),
                      for (Ressource ressource
                          in GameFile().ressourcesManager.ressources)
                        Expanded(
                            child: Text(
                          "${ressource.getName()}:${ressource.value}/${GameFile().boatContainerSize * GameFile().building.getValue(BuildingCaracteritics.boatStockage)}",
                        ))
                    ],
                  )
                ],
              ),
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Personnes',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Batiments',
                            ),
                            for (BuildingCaracteritic bc
                                in GameFile().building.buildingCaracteristics)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.grey),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            bc.getName(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${bc.getLevel()}/${bc.getLevelMax()} améliorations",
                                          ),
                                          Text(bc.getNeededForUpgrade()),
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
                                            child: const Text(
                                              "Améliorer ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Robot',
                            ),
                            for (RobotCaracteritic rc
                                in GameFile().robot.robotCaracteristics)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.grey),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            rc.getName(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Go to Ocean !"),
                  Column(
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ],
              ))
            ],
          ),
          if (!seenIntro)
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    top: MediaQuery.of(context).size.height - 300),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(190, 190, 190, 1),
                        border: Border.all(
                            width: 10,
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 8, 60, 156)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: AnimatedTextKit(
                              onTap: () {
                                seenIntro = true;
                                GameFile().seenIntro = true;
                                setState(() {});
                              },
                              totalRepeatCount: 1,
                              pause: const Duration(milliseconds: 2500),
                              onFinished: () {
                                seenIntro = true;
                                GameFile().seenIntro = true;
                                setState(() {});
                              },
                              animatedTexts: [
                                TyperAnimatedText('Oh welcome to the Team !',
                                    textStyle: dialogStyle),
                                TyperAnimatedText(
                                    "I'm Julia, the leader of the Project Ocean team. You are the new drone pilot aren't you ?",
                                    textStyle: dialogStyle),
                                TyperAnimatedText(
                                    "As I told you, our mission is to clear the trash from ocean, and we waited for you to start !",
                                    textStyle: dialogStyle),
                                TyperAnimatedText(
                                    "To be honnest, for now, our robot is veary weak and have a small battery, but I hope that with all the trash outhere, and the help of the team, we will be able to upgrade that.",
                                    textStyle: dialogStyle),
                                TyperAnimatedText(
                                    "So when you're ready, we take the boat and start our journey. I'm so excited to finally getting started !",
                                    textStyle: dialogStyle),
                              ]),
                        ),
                      )),
                ))
        ]),
      ),
    );
  }
}
