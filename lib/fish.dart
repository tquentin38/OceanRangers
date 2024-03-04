import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FishBackgroundWidget extends StatefulWidget {
  final double baseTop;
  final double secondDelay;
  const FishBackgroundWidget(this.baseTop, this.secondDelay, {super.key});
  @override
  State createState() => _FishBackgroundState();
}

class _FishBackgroundState extends State<FishBackgroundWidget> {
  double topFish = 100;
  Timer? timer;
  int angleCount = 0;
  double valueAvance = 0;
  double rightFish = -150;

  late double baseTop = widget.baseTop;
  late double secondDelay = widget.secondDelay;
  _FishBackgroundState();
  double timeSinceStart = 0;
  bool started = false;

  void updatePosition() {
    if (!started) {
      timeSinceStart += 10 / 1000;
      if (timeSinceStart >= secondDelay) {
        started = true;
      }
    } else {
      angleCount += 1;
      valueAvance += 0.1;
      if (angleCount > 360) {
        angleCount = 0;
      }
      if (valueAvance > 100) {
        valueAvance = 0;
      }

      setState(() {
        topFish = baseTop + sin(angleCount * pi / 180) * 100;

        rightFish = (100 - valueAvance) /
                100 *
                (MediaQuery.of(context).size.width + 150) -
            150;
      });
      //debugPrint("$valueAvance - $rightFish - $topFish");
    }
    //debugPrint(sin(angle_count * pi / 180).toString());
  }

  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();
    // 3. initialize Ticker
    _ticker = Ticker((elapsed) {
      // 4. update state
      updatePosition();
    });
    // 5. start ticker
    _ticker.start();
  }

  @override
  void dispose() {
    // 6. don't forget to dispose it
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topFish,
      right: rightFish,
      child: GestureDetector(
        child: Image(image: FileImage(File("assets/fish_1s.png"))),
      ),
    );
  }
}
