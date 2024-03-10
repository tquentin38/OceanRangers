import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rangers/core/game_file.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                    image:
                        const AssetImage("assets/intro/lettre_admission.jpg"),
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
                    image: const AssetImage("assets/intro/2149064269.jpg"),
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
                    image: const AssetImage("assets/intro/train.jpg"),
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
                      image: const AssetImage("assets/intro/marina.jpg"),
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fill,
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
                Navigator.pushReplacementNamed(context, "/intro3");
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
              Navigator.pushReplacementNamed(context, "/intro3");
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
      /*Positioned(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        right: 0,
        bottom: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(), color: Colors.grey),
              child: ,
            )),
      ),*/

      /*Container(
        child: AnimatedBuilder(
          animation: _controller,
          child: Container(
            color: Colors.green,
            child: const Center(
              child: Text('Whee!'),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _controller.value * 2.0 * 3.14,
              child: child,
            );
          },
        ),
      ),*/
    ]));
  }
}
