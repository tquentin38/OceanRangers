import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';
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
      fontSize: 15, color: Colors.black, decoration: TextDecoration.none);

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

  @override
  Widget build(BuildContext context) {
    double width = getMaxedSize(context).x;
    double height = getMaxedSize(context).y;
    return Stack(children: [
      if (!widget.ended)
        Padding(
            padding: EdgeInsets.only(left: width * 0.1, top: height * 0.1),
            child: SizedBox(
              width: width * 0.8,
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
                                      textAlign: TextAlign.center,
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
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      )
                                    else
                                      const Icon(
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
