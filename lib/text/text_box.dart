import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class WaitingTextBox {
  final String text;
  final int timeout;

  WaitingTextBox(this.text, this.timeout);
}

class TextManager {
  MyTextBox? currentTextBox;
  List<WaitingTextBox> waitingFile = [];
  Vector2 boxPosition = Vector2(0, 0);
  late OceanGame game;

  void setBoxPosition(Vector2 newPosition) {
    boxPosition = newPosition.clone();
  }

  void setGame(OceanGame newGame) {
    game = newGame;
  }

  void addTextToDisplay(String text, int timeout, bool priority) {
    WaitingTextBox waitingTextBox = WaitingTextBox(text, timeout);
    if (priority) {
      if (currentTextBox != null) currentTextBox?.removeFromParent();

      displayBox(waitingTextBox);
    } else {
      waitingFile.add(waitingTextBox);
      if (currentTextBox == null) displayNexText();
    }
  }

  void displayNexText() {
    if (waitingFile.isNotEmpty) {
      WaitingTextBox nextBox = waitingFile[0];
      displayBox(nextBox);
      waitingFile.remove(nextBox);
    }
  }

  void displayBox(WaitingTextBox waitingTextBox) {
    MyTextBox textBox = MyTextBox(boxPosition, waitingTextBox.text);
    Future.delayed(Duration(seconds: waitingTextBox.timeout), () {
      // Do something
      if (textBox.isLoaded) {
        textBox.removeFromParent();
        currentTextBox = null;
      }
      displayNexText();
    });
    currentTextBox = textBox;
    game.add(textBox);
  }
}

final regular = TextPaint(
  style: const TextStyle(
      fontSize: 20.0,
      color: Color.fromARGB(255, 70, 101, 202),
      fontWeight: FontWeight.bold),
);

class MyScrollableText extends ScrollTextBoxComponent {
  MyScrollableText(Vector2 frameSize, String text)
      : super(
          size: frameSize,
          text: text,
          textRenderer: regular,
          boxConfig: TextBoxConfig(timePerChar: 0.05),
        );
}

class MyTextBox extends TextBoxComponent {
  MyTextBox(Vector2 position, String text)
      : super(
            text: text,
            textRenderer: regular,
            boxConfig: TextBoxConfig(timePerChar: 0.05, maxWidth: 800),
            position: position,
            size: Vector2(800, 80));

  final bgPaint = Paint()..color = const Color.fromARGB(255, 0, 0, 0);
  final borderPaint = Paint()
    ..color = const Color.fromARGB(255, 197, 197, 197)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(boxConfig.margins.left), borderPaint);
    super.render(canvas);
  }
}
