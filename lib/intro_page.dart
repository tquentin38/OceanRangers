import 'dart:async';

import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<IntroPage> createState() => _WelcomePageState();
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

class _WelcomePageState extends State<IntroPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  );

  bool _first = true;
  bool selected = false;
  bool showLetter4 = false;
  double turns = 0;
  bool show1 = false;
  bool show2 = false;
  bool show3 = false;
  bool show4 = false;
  int state = 0;

  @override
  void initState() {
    super.initState();
    _controller.repeat();

    Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (mounted) {
        debugPrint("State : $state");
        switch (state) {
          case 0:
            show1 = true;
            break;
          //anim case 2
          case 1:
            show2 = true;
            turns = 10;
            break;
          case 2:
            show3 = true;
            break;
          //anim case 3
          case 3:
            _first = !_first;
            break;
          case 4:
            show4 = true;
            break;
          //anim case 4
          case 5:
            selected = !selected;
            showLetter4 = true;
            break;
          //reset anim
          case 6:
            showLetter4 = false;
            show1 = false;
            show3 = false;
            show4 = false;
            show2 = false;
            turns = 0;
            _first = !_first;
            selected = !selected;
            break;
        }
        state++;
        if (state > 6) {
          state = 0;
        }
        setState(() {});
      }
      if (!mounted) t.cancel();
    });
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
                child: Image(
                  image: const AssetImage("assets/intro/intro_1_cuisine.jpg"),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fill,
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
                child: AnimatedRotation(
                  turns: turns,
                  duration: const Duration(seconds: 3),
                  curve: Curves.decelerate,
                  onEnd: () {
                    debugPrint("Ended rotation OMG !");
                  },
                  child: Image(
                    image: const AssetImage("assets/intro/intro_2_news.jpg"),
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
                  child: AnimatedCrossFade(
                    duration: const Duration(seconds: 1),
                    firstChild: Image(
                      image: const AssetImage(
                          "assets/intro/intro_3_enveloppe_open.jpg"),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    secondChild: Image(
                      image: const AssetImage(
                          "assets/intro/intro_3_enveloppe_closed.jpg"),
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    crossFadeState: _first
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  )
                  // ,
                  ),
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
                      image: const AssetImage("assets/intro/4_mail_box.jpg"),
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fill,
                    ),
                    AnimatedAlign(
                      alignment: selected
                          ? const Alignment(-0.1, -0.35)
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
                              image: AssetImage(
                                  "assets/intro/intro_3_enveloppe_closed.jpg"),
                              height: 75,
                              width: 75,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
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
