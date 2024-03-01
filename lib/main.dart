import 'dart:async';

import 'package:challenge2024/boat/boat_alliance.dart';
import 'package:challenge2024/boat/boat_batiment.dart';
import 'package:challenge2024/boat/boat_machines.dart';
import 'package:challenge2024/boat/boat_overview_part.dart';
import 'package:challenge2024/boat/boat_port.dart';
import 'package:challenge2024/boat/boat_port_overview.dart';
import 'package:challenge2024/boat/boat_quest.dart';
import 'package:challenge2024/boat/boat_robot.dart';
import 'package:challenge2024/boat/boat_staff.dart';
import 'package:challenge2024/boat/boat_tech.dart';
import 'package:challenge2024/boat/boat_wheel_houses.dart';
import 'package:challenge2024/core/game_file.dart';
import 'package:challenge2024/ocean_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overlays/game_over.dart';
import 'overlays/go_back.dart';

void startGame() {}
void main() {
  //init gamefile
  GameFile();
  runApp(const MyApp());
}

class MouseInfos {
  static final MouseInfos _instance = MouseInfos._internal();

  //Load all information about the game
  Vector2 position = Vector2(0, 0);
  bool isTap = false;

  factory MouseInfos() {
    return _instance;
  }

  MouseInfos._internal() {
    // initialization logic
  }
}

class GameOceanWidget extends StatelessWidget {
  final MouseInfos mouseInfos = MouseInfos();

  GameOceanWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerHover: (event) {
        MouseInfos().isTap = false;
        MouseInfos().position = Vector2(event.position.dx, event.position.dy);
        //debugPrint("onPointerMove FALSE ${event.position}");
      }, // not pressed
      onPointerMove: (event) {
        MouseInfos().isTap = true;
        MouseInfos().position = Vector2(event.position.dx, event.position.dy);
        //debugPrint("onPointerMove TRUE ${event.position}");
      }, // pressed
      child: GestureDetector(
        onTapDown: (details) {
          MouseInfos().isTap = true;
          //debugPrint("ON TAP TRUE");
        },
        onTap: () {
          MouseInfos().isTap = false;

          //debugPrint("ON TAP FALSE");
        },
        onTapCancel: () {
          MouseInfos().isTap = false;

          //debugPrint("ON TAP CANCEL");
        },
        child: GameWidget<OceanGame>.controlled(
          gameFactory: OceanGame.new,
          overlayBuilderMap: {
            'GameOver': (_, game) => GameOver(game: game),
            'GoBack': (_, game) => GoBack(game: game),
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/techguy.png"), context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      onGenerateRoute: (settings) {
        if (settings.name == "/boat") {
          return CupertinoPageRoute(
              builder: (context) => const BoatOverview(), settings: settings);
        }
        if (settings.name == "/boat/wheel") {
          return CupertinoPageRoute(
              builder: (context) => const WheelHouses(), settings: settings);
        }
        if (settings.name == "/boat/ong") {
          return CupertinoPageRoute(
              builder: (context) => const AlliancePage(), settings: settings);
        }
        if (settings.name == "/boat/quest") {
          return CupertinoPageRoute(
              builder: (context) => const QuestPage(), settings: settings);
        }
        if (settings.name == "/boat/staff") {
          return CupertinoPageRoute(
              builder: (context) => const BoatStaff(), settings: settings);
        }
        if (settings.name == "/boat/machine") {
          return CupertinoPageRoute(
              builder: (context) => const BoatMachines(), settings: settings);
        }
        if (settings.name == "/boat/machine/batiment") {
          return CupertinoPageRoute(
              builder: (context) => const BoatBatimentPage(),
              settings: settings);
        }
        if (settings.name == "/boat/elec") {
          return CupertinoPageRoute(
              builder: (context) => const BoatTech(), settings: settings);
        }
        if (settings.name == "/boat/elec/robot") {
          return CupertinoPageRoute(
              builder: (context) => const BoatRobotPage(), settings: settings);
        }
        if (settings.name == "/boat/port") {
          return CupertinoPageRoute(
              builder: (context) => const PortOverview(), settings: settings);
        }
        if (settings.name == "/boat/marina") {
          return CupertinoPageRoute(
              builder: (context) => const Port(), settings: settings);
        }
        return null;
      },
      //home: MyWidget()
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    if (GameFile().uuid == null) {
      Timer.periodic(const Duration(milliseconds: 150), (Timer t) {
        if (GameFile().uuid != null) {
          if (mounted) setState(() {});
          t.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientText(
                          'Project Aqua',
                          style: TextStyle(
                              fontSize: 80, fontWeight: FontWeight.bold),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 61, 161, 243),
                            Color.fromARGB(255, 12, 71, 160),
                          ]),
                        ),
                      ],
                    )),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 79, 224),
                                elevation: 0,
                              ),
                              onPressed: () {
                                /*Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => BoatPage()),
                                );*/
                                Navigator.pushReplacementNamed(
                                    context, "/boat");
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Start",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text("V0.1.0-beta"),
              if (GameFile().uuid != null)
                Text("${GameFile().pseudo} (${GameFile().uuid})"),
              GestureDetector(
                  onTap: () async {
                    debugPrint("RESET ASKED");
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    // Remove data for the 'counter' key.
                    await prefs.remove('UUID');
                  },
                  child: const Text("©Juliette Chappaz & Thibaut Quentin")),
            ])));
  }
}
