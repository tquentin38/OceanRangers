import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

// ignore: must_be_immutable
class BoatDialog extends StatefulWidget {
  final List<String> dialogs;
  bool ended = false;
  BoatDialog({super.key, required this.dialogs});

  bool isEnded() {
    return ended;
  }

  @override
  State<BoatDialog> createState() => _BoatDialogState();
}

class _BoatDialogState extends State<BoatDialog> {
  TextStyle dialogStyle = const TextStyle(
      fontSize: 25, color: Colors.black, decoration: TextDecoration.none);

  bool active = false;

  @override
  void initState() {
    debugPrint("Init state dialog : ${widget.dialogs}");
    super.initState();
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
    return Stack(children: [
      if (!widget.ended)
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
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 2500),
                          onFinished: () {
                            widget.ended = true;
                            setState(() {});
                          },
                          animatedTexts: [
                            for (String dialog in widget.dialogs)
                              TyperAnimatedText(dialog, textStyle: dialogStyle),
                          ]),
                    ),
                  )),
            )),
    ]);
  }
}
