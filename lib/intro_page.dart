import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rangers/core/game_file.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<IntroPage> {
  bool _first = true;
  bool selected = false;
  bool showLetter4 = false;
  double turns = 0;
  bool show1 = false;
  bool show2 = false;
  bool show3 = false;
  bool show4 = false;
  bool show5 = false;
  int state = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    GameFile().getAudioPlayer().stop();
    GameFile()
        .getAudioPlayer()
        .play(AssetSource('audio/intro_music.mp3'), volume: 0.5);

    GameFile().getAudioPlayer().onPlayerComplete.listen((event) {
      if (mounted) {
        GameFile()
            .getAudioPlayer()
            .play(AssetSource('audio/intro_music.mp3'), volume: 0.5);
      }
    });

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (mounted) {
        debugPrint("State : $state");
        switch (state) {
          //anim case 1
          case 0:
            if (turns == 0) {
              turns = 10;
            } else {
              turns = 0;
            }
            show1 = true;
            break;
          case 1:
            break;
          //anim case 2
          case 3:
            show2 = true;
            break;
          case 4:
            break;
          //anim case 3
          case 5:
            show3 = true;
            _first = !_first;
            break;
          case 6:
            show4 = true;
            break;
          //anim case 4
          case 7:
            selected = !selected;
            showLetter4 = true;
            break;
          case 8:
            show5 = true;
            break;
          //reset anim
          case 9:
            showLetter4 = false;
            show1 = false;
            show3 = false;
            show4 = false;
            show2 = false;
            show5 = false;
            _first = !_first;
            selected = !selected;
            break;
        }
        state++;
        if (state > 8) {
          t.cancel();
          state = -2;
        }
        if (mounted) setState(() {});
      }
      if (!mounted) t.cancel();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        left: 0,
        top: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCrossFade(
              crossFadeState:
                  show1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(seconds: 2),
              secondChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
              ),
              firstChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
                child: AnimatedRotation(
                  turns: turns,
                  duration: const Duration(seconds: 3),
                  curve: Curves.decelerate,
                  onEnd: () {
                    debugPrint("Ended rotation OMG !");
                  },
                  child: Image(
                    image: const AssetImage("assets/intro/journald.jpg"),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
            )),
      ),
      Positioned(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        right: 0,
        top: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCrossFade(
              crossFadeState:
                  show2 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(seconds: 2),
              secondChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
              ),
              firstChild: Container(
                  decoration:
                      BoxDecoration(border: Border.all(), color: Colors.grey),
                  child: Image(
                    image: const AssetImage("assets/intro/letter_open.png"),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 2,
                  )),
            )),
      ),
      Positioned(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        left: 0,
        bottom: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCrossFade(
              crossFadeState:
                  show3 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(seconds: 2),
              secondChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
              ),
              firstChild: Container(
                  decoration:
                      BoxDecoration(border: Border.all(), color: Colors.grey),
                  child: Image(
                    image: const AssetImage("assets/intro/recherche_job.jpg"),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 2,
                  )),
            )),
      ),
      Positioned(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        right: 0,
        bottom: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedCrossFade(
              crossFadeState:
                  show4 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(seconds: 2),
              secondChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
              ),
              firstChild: Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.grey),
                child: Stack(
                  children: [
                    Image(
                      image: const AssetImage("assets/intro/poste.jpg"),
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fill,
                    ),
                    AnimatedAlign(
                      alignment: selected
                          ? const Alignment(0.3, -0.35)
                          : const Alignment(-2, 0),
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      onEnd: () {
                        showLetter4 = false;
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          if (showLetter4)
                            const Image(
                              image: AssetImage("assets/intro/enveloppe.png"),
                              height: 125,
                              width: 125,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      if (!show5)
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
                Navigator.pushReplacementNamed(context, "/intro2");
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
              show5 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 2),
          secondChild: Container(),
          firstChild: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/intro2");
            },
            child: const Icon(
              Icons.arrow_right_alt,
              size: 100,
              color: Color.fromARGB(207, 86, 160, 57),
              weight: 150,
            ),
          ),
        ),
      ),
    ]));
  }
}
