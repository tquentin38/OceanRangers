import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:ocean_rangers/boat/boat_alliance.dart';
import 'package:ocean_rangers/boat/boat_batiment.dart';
import 'package:ocean_rangers/boat/boat_machines.dart';
import 'package:ocean_rangers/boat/boat_market.dart';
import 'package:ocean_rangers/boat/boat_ong.dart';
import 'package:ocean_rangers/boat/boat_overview_part.dart';
import 'package:ocean_rangers/boat/boat_port.dart';
import 'package:ocean_rangers/boat/boat_quest.dart';
import 'package:ocean_rangers/boat/boat_robot.dart';
import 'package:ocean_rangers/boat/boat_staff.dart';
import 'package:ocean_rangers/boat/boat_tech.dart';
import 'package:ocean_rangers/boat/boat_wheel_houses.dart';
import 'package:ocean_rangers/config_page.dart';
import 'package:ocean_rangers/core/game_file.dart';
import 'package:ocean_rangers/intro_page.dart';
import 'package:ocean_rangers/intro_page3.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rangers/overlays/infos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'intro_page2.dart';
import 'overlays/game_over.dart';
import 'overlays/go_back.dart';

void main() async {
  //init gamefile
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  GameFile();
  runApp(const MyApp());

  SemanticsBinding.instance.ensureSemantics();
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
      },
      onPointerMove: (event) {
        MouseInfos().isTap = true;
        MouseInfos().position = Vector2(event.position.dx, event.position.dy);
      },
      child: GestureDetector(
        onTapDown: (details) {
          MouseInfos().isTap = true;
        },
        onTap: () {
          MouseInfos().isTap = false;
        },
        onTapCancel: () {
          MouseInfos().isTap = false;
        },
        child: GameWidget<OceanGame>.controlled(
          gameFactory: OceanGame.new,
          overlayBuilderMap: {
            'GameOver': (_, game) => GameOver(game: game),
            'GoBack': (_, game) => GoBack(game: game),
            'Infos': (_, game) => Infos(game: game),
          },
        ),
      ),
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //precacheImage(const AssetImage("assets/images/techguy.png"), context);
    return MaterialApp(
      title: 'Ocean Rangers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/boat":
            return CupertinoPageRoute(
                builder: (context) => const BoatOverview(), settings: settings);
          case "/boat/market":
            return CupertinoPageRoute(
                builder: (context) => const MarketPage(), settings: settings);
          case "/boat/ongPage":
            return CupertinoPageRoute(
                builder: (context) => const ONGPage(), settings: settings);
          case "/boat/wheel":
            return CupertinoPageRoute(
                builder: (context) => const WheelHouses(), settings: settings);
          case "/boat/ong":
            return CupertinoPageRoute(
                builder: (context) => const AlliancePage(), settings: settings);
          case "/boat/quest":
            return CupertinoPageRoute(
                builder: (context) => const QuestPage(), settings: settings);
          case "/boat/staff":
            return CupertinoPageRoute(
                builder: (context) => const BoatStaff(), settings: settings);
          case "/boat/machine":
            return CupertinoPageRoute(
                builder: (context) => const BoatMachines(), settings: settings);
          case "/boat/machine/batiment":
            return CupertinoPageRoute(
                builder: (context) => const BoatBatimentPage(),
                settings: settings);
          case "/boat/elec":
            return CupertinoPageRoute(
                builder: (context) => const BoatTech(), settings: settings);
          case "/boat/elec/robot":
            return CupertinoPageRoute(
                builder: (context) => const BoatRobotPage(),
                settings: settings);
          case "/boat/marina":
            return CupertinoPageRoute(
                builder: (context) => const Port(), settings: settings);
          case "/intro":
            return CupertinoPageRoute(
                builder: (context) => const IntroPage(), settings: settings);
          case "/intro2":
            return CupertinoPageRoute(
                builder: (context) => const IntroPage2(), settings: settings);
          case "/intro3":
            return CupertinoPageRoute(
                builder: (context) => const IntroPage3(), settings: settings);
          case "/config":
            return CupertinoPageRoute(
                builder: (context) => const ConfigPage(), settings: settings);
          default:
            return null;
        }
      },
      navigatorObservers: [routeObserver],
      //home: MyWidget()
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

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
      Timer.periodic(const Duration(seconds: 3), (Timer t) {
        if (mounted) {
          try {
            /*GameFile().getAudioPlayer().play(
                AssetSource('audio/big-bubbles-2-169078.mp3'),
                volume: 0.4);*/
            t.cancel();
          } catch (error) {
            debugPrint(error.toString());
          }
        } else {
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
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage("assets/images/homescreen.jpg"),
            fit: BoxFit.fill,
          )),
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 79, 224),
                        elevation: 0,
                      ),
                      onPressed: () {
                        debugPrint(
                            "IS INTRO PASSED : ${GameFile().isIntroPassed}");
                        if (!GameFile().isIntroPassed) {
                          Navigator.pushReplacementNamed(context, "/intro");
                        } else {
                          Navigator.pushReplacementNamed(context, "/boat");
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Start",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text("V1.1.0"),
            if (GameFile().uuid != null)
              Text("${GameFile().pseudo} (${GameFile().uuid})"),
            GestureDetector(
                onTap: () async {
                  debugPrint("RESET ASKED");
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  // Remove data for the 'counter' key.
                  await prefs.clear();
                },
                child: const Text("©Juliette Chappaz & Thibaut Quentin")),
          ])),
    ]));
  }
}
