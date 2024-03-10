import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';

import 'boat/boat_dialog.dart';
import 'core/game_file.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  bool seenIntro = GameFile().seenIntro;
  TextStyle dialogStyle = const TextStyle(fontSize: 25);
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  bool showBoatDialog = false;
  BoatDialog? boatDialog;
  bool showNext = false;
  int count = 0;

  @override
  void initState() {
    super.initState();

    GameFile().getAudioPlayer().onPlayerComplete.listen((event) {
      if (mounted) {
        GameFile()
            .getAudioPlayer()
            .play(AssetSource('audio/intro_music.mp3'), volume: 0.5);
      }
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {});
        if (boatDialog != null) {
          if (boatDialog!.ended) {
            showNext = true;
            count++;
            if (count > 5) {
              Navigator.pushReplacementNamed(context, "/boat");
            }
          }
        }
      } else {
        t.cancel();
      }
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        debugPrint("START DIALOGUE");
        boatDialog = BoatDialog(
            dialogHolder: DialogHolder(dialogs: [
          "Commander: Good morning and welcome aboard! I'm the commander of this vessel, and it's a pleasure to have you join our TRASP mission.",
          "Assistant Captain: Hello! I'm Rebecca, the assistant captain and marine biologist here.",
          "Commander: We were looking forward to working with our state-of-the-art ship, but unfortunately, we've hit a bit of a snag. Our intended ship is currently unavailable due to unforeseen maintenance issues.",
          "Assistant Captain: Despite the setback with our main ship, we have an older vessel at our disposal. It's not what we're used to, but it has character, and with some hard work, I believe it can serve our purpose.",
          "Commander: The exploration robot, much like the ship, has seen better days. But, it's what we've got, and I'm confident in our team's ability to get it back in shape.",
          "Commander: We're a resourceful bunch, and this mission gives us the perfect opportunity to prove that.",
          "Assistant Captain: Exactly. Our journey might be a bit more challenging than initially planned, but it's nothing we can't handle together. ",
          "Assistant Captain: We'll need your expertise to help refurbish the robot and ensure it's ready for our exploration tasks. It's going to be a unique adventure, and your role is crucial.",
          "Commander: We appreciate your flexibility and willingness to adapt to these unexpected circumstances. This mission is about more than just the equipment; it's about the heart and determination we bring."
              "Commander: Are you ready to embark on this journey with us?"
        ], hearts: 0, people: null));
        showBoatDialog = true;
        setState(() {});
      }
      t.cancel();
    });
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
    return Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage("assets/intro/meeting.png"),
            fit: BoxFit.fill,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 3,
          left: MediaQuery.of(context).size.height / 10,
          bottom: 0,
          child: const Image(
            image: AssetImage("assets/images/commandante.png"),
            fit: BoxFit.fill,
          )),
      Positioned(
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width / 3,
          left: MediaQuery.of(context).size.width / 10 * 6,
          bottom: 0,
          child: const Image(
            image: AssetImage("assets/images/seconde.png"),
            fit: BoxFit.fill,
          )),
      if (!showNext)
        Positioned(
          height: 35,
          width: 90,
          right: 20,
          bottom: 20,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(),
                color: const Color.fromARGB(143, 158, 158, 158)),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/boat");
              },
              child: const Text(
                "SKIP",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      Positioned(
        height: 100,
        width: 100,
        right: 10,
        bottom: 10,
        child: AnimatedCrossFade(
          crossFadeState:
              showNext ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 2),
          secondChild: Container(),
          firstChild: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/boat");
            },
            child: const Icon(
              Icons.arrow_right_alt,
              size: 100,
              color: Color.fromARGB(255, 0, 0, 0),
              weight: 150,
            ),
          ),
        ),
      ),
      if (showBoatDialog) boatDialog!,
    ]);
  }
}
