import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});
  @override
  State createState() => __PlayerState();
}

class __PlayerState extends State<PlayerWidget> {
  double imageSize = 240;
  double top = 50;
  double left = 50;
  double deltaTop = 60;
  double deltaLeft = 120;
  double sensibility = 0.5;
  int countUp = 0;

  Timer? timer;
  update() {
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyZ)) {
      if (top > 0) {
        top -= sensibility;
        if (top < 0) {
          top = 0;
        }
      }
      debugPrint("Top : $top");
    }
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyQ)) {
      if (left > 0) {
        left -= sensibility;
        if (left < 0) {
          left = 0;
        }
      }
    }

    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyS)) {
      if (top < 100) {
        top += sensibility;
        if (top > 100) {
          top = 100;
        }
      }
    }
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyD)) {
      if (left < 100) {
        left += sensibility;
        if (top > 100) {
          top = 100;
        }
      }
    }
    setState(() {});
  }

  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();
    // 3. initialize Ticker
    _ticker = Ticker((elapsed) {
      // 4. update state
      update();
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

  /*@override
  void initState() {
    super.initState();
    /*_focusAttachment = _focusNode.attach(context, onKeyEvent: (node, event) {
      //Get only down & repeat
      if (event is KeyUpEvent) {
        return KeyEventResult.handled;
      }

      //debugPrint("Pressed {$event.logicalKey}  ");
      return KeyEventResult.handled;
    });*/
    timer =
        Timer.periodic(const Duration(milliseconds: 10), (Timer t) => update());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    // _focusAttachment.reparent();
    return Positioned(
      top: (MediaQuery.of(context).size.height - 180) * top / 100 - 60,
      left: (MediaQuery.of(context).size.width - 240) * left / 100,
      child: GestureDetector(
        child: Image(image: FileImage(File("assets/player_fishs.png"))),
      ),
    );
  }
}
