import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ocean_rangers/core/people/people_manager.dart';

class DialogHolder {
  final List<String> dialogs;
  final People? people;
  final int hearts;
  DialogHolder(
      {required this.dialogs, required this.hearts, required this.people});
}

// ignore: must_be_immutable
class BoatDialog extends StatefulWidget {
  final DialogHolder dialogHolder;
  bool ended = false;
  BoatDialog({super.key, required this.dialogHolder});

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
    debugPrint("Init state dialog : ${widget.dialogHolder.dialogs}");
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
                top: MediaQuery.of(context).size.height - 220),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(190, 190, 190, 1),
                    border: Border.all(
                        width: 10,
                        style: BorderStyle.solid,
                        color: const Color.fromARGB(255, 8, 60, 156)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedTextKit(
                              totalRepeatCount: 1,
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                              pause: const Duration(milliseconds: 2500),
                              onFinished: () {
                                widget.ended = true;
                                setState(() {});
                              },
                              animatedTexts: [
                                for (String dialog
                                    in widget.dialogHolder.dialogs)
                                  TyperAnimatedText(dialog,
                                      textStyle: dialogStyle),
                              ]),
                          if (widget.dialogHolder.people != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i <
                                          widget.dialogHolder.people!.type
                                              .levelMax;
                                      i++)
                                    if (widget
                                            .dialogHolder.people!.heartPoint >=
                                        widget.dialogHolder.people!.type
                                            .valueForLevel[i])
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      )
                                    else
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.black,
                                      )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  )),
            )),
    ]);
  }
}
