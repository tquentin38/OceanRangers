import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../ocean_game.dart';

class BackgroundComponent extends PositionComponent
    with HasGameReference<OceanGame> {
  BackgroundComponent({super.priority = -5});

  Paint painter =
      const PaletteEntry(Color.fromARGB(255, 126, 182, 217)).paint();
  double lastDeep = 0;
  int last = -1;
  Vector2 lastScreenSize = Vector2(0, 0);
  Vector2 boatSize = Vector2(0, 0);
  @override
  void onLoad() {}

  void updateColor(double deep) {
    if (deep <= 0) {
      painter.color = const Color.fromARGB(255, 126, 182, 217);
    } else if (deep > 1000) {
      painter.color = const Color.fromARGB(255, 1, 28, 32);
    } else {
      painter.color = Color.fromARGB(
          255,
          1 + (125 * (1000 - deep) / 1000).round(),
          28 + (154 * (1000 - deep) / 1000).round(),
          32 + (185 * (1000 - deep) / 1000).round());
    }
    lastDeep = deep;
  }

  @override
  void onGameResize(Vector2 size) {
    lastScreenSize = size;
    super.onGameResize(size);

    double x = size.x;
    double y = size.y;
    if (x > 1920) {
      x = 1920;
    }
    if (y > 1080) {
      y = 1080;
    }
    boatSize = Vector2(x, y);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.largest, painter);
    if (lastDeep < 11) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, lastScreenSize.x,
              lastScreenSize.y / 2 * (10 - lastDeep) / 10),
          const PaletteEntry(Color.fromARGB(255, 204, 228, 247)).paint());
      if (game.objectSpeed.x < 0 || game.objectSpeed.x == 0 && last == -1) {
        last = -1;
      } else {
        last = 1;
      }
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(
              lastScreenSize.x / 2 - boatSize.x * 0.4,
              lastScreenSize.y / 2 * (10 - lastDeep) / 10 - boatSize.y * 0.4,
              boatSize.x * 0.8,
              boatSize.y * 0.6),
          image: game.images.fromCache('bateau.png'),
          fit: BoxFit.fill,
          repeat: ImageRepeat.noRepeat,
          scale: 2.0,
          alignment: Alignment.center,
          flipHorizontally: (last == -1),
          filterQuality: FilterQuality.high);
      canvas.restore();
    }

    super.render(canvas);
  }
}
