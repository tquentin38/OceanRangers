import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/boat/boat_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocean_rangers/boat/boat_utils.dart';

import '../core/game_file.dart';

class BoatStaff extends StatefulWidget {
  const BoatStaff({super.key});

  @override
  State<BoatStaff> createState() => _BoatStaffState();
}

class _BoatStaffState extends State<BoatStaff> {
  bool seenIntro = GameFile().seenIntro;
  bool showBoatDialog = false;
  TextStyle titleSize = const TextStyle(fontSize: 25);
  TextStyle normalSize = const TextStyle(fontSize: 15);
  bool isHover = false;
  String hoverValue = "Error: no hover !";
  BoatDialog? boatDialog;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double mouseX = 0.0;
  double mouseY = 0.0;

// fetches mouse pointer location
  void _updatelocation(PointerHoverEvent details) {
    setState(() {
      mouseX = details.position.dx;
      mouseY = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = getMaxedSize(context).x;
    double height = getMaxedSize(context).y;
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(
            left: getPaddingSide(context),
            right: getPaddingSide(context),
            top: getPaddingVertical(context),
            bottom: getPaddingVertical(context)),
        child: Stack(children: [
          SizedBox(
              height: height,
              width: width,
              child: const Image(
                image: AssetImage("assets/images/staff_room.jpg"),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: height,
            width: width,
          ),
          Positioned(
              top: height / 4.5 + height / 8 - 50,
              left: width / 5 + width / 8 - 50,
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              top: height / 2.25 + height / 8 - 50,
              left: width - (width / 4.5 + width / 8 + 50),
              child: const Icon(
                Icons.crisis_alert,
                size: 100,
                color: Color.fromARGB(255, 185, 0, 0),
                weight: 150,
              )),
          Positioned(
              height: height / 4,
              width: width / 4,
              top: height / 4.5,
              left: width / 5,
              child: GestureDetector(
                onTap: () => {Navigator.pushReplacementNamed(context, "/boat")},
                child: MouseRegion(
                  //child: Container(decoration: BoxDecoration(color: Colors.black)),
                  hitTestBehavior: HitTestBehavior.opaque,
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    isHover = true;
                    hoverValue = "Go back";
                    setState(() {});
                  },
                  onExit: (event) {
                    isHover = false;
                    setState(() {});
                  },
                  onHover: _updatelocation,
                ),
              )),
          Positioned(
              height: height / 4,
              width: width / 4,
              top: height / 2.25,
              left: width - (width / 4.5 + width / 4),
              child: GestureDetector(
                onTap: () =>
                    {Navigator.pushReplacementNamed(context, "/boat/quest")},
                child: MouseRegion(
                  //child: Container(decoration: BoxDecoration(color: Colors.black)),
                  hitTestBehavior: HitTestBehavior.opaque,
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    isHover = true;
                    hoverValue = "Go to quest";
                    setState(() {});
                  },
                  onExit: (event) {
                    isHover = false;
                    setState(() {});
                  },
                  onHover: _updatelocation,
                ),
              )),
          const BoatHUD(),
          if (isHover)
            Positioned(
              top: mouseY + 10 - getPaddingVertical(context),
              left: mouseX + 10 - getPaddingSide(context),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hoverValue,
                    style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ),
          if (showBoatDialog) boatDialog!,
        ]),
      ),
    );
  }
}
