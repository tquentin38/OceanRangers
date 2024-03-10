import 'package:ocean_rangers/managers/world_manager.dart';
import 'package:ocean_rangers/ocean_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Hud extends PositionComponent with HasGameReference<OceanGame> {
  final WorldManager worldManager;
  bool debugInfos = true;
  Hud({
    required this.worldManager,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;
  late TextComponent _deepTextComponent;
  late TextComponent _infosTextComponent;
  late TextComponent _debugTextComponent;
  late SpriteComponent _starComponent;

  @override
  Future<void> onLoad() async {
    _infosTextComponent = TextComponent(
      text: "Health: xyz/xyz\nElectrical power : xyz kWh\nPressure: xxx hPa",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(0, 0),
    );
    add(_infosTextComponent);

    if (debugInfos) {
      _debugTextComponent = TextComponent(
        text: "Health: xyz/xyz\nElectrical power : xyz kWh\nPressure: xxx hPa",
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            color: Color.fromRGBO(10, 10, 10, 1),
          ),
        ),
        anchor: Anchor.topLeft,
        position: Vector2(0, game.size.y - 300),
      );
      add(_debugTextComponent);
    }

    _scoreTextComponent = TextComponent(
      text: "${game.spaceUsed}/${game.maxSpace}",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 60),
    );
    add(_scoreTextComponent);

    _deepTextComponent = TextComponent(
      text: "${worldManager.getDeep()} m",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 75, 20),
    );
    add(_deepTextComponent);

    final starSprite = await game.loadSprite('conserves.png');

    _starComponent = SpriteComponent(
      sprite: starSprite,
      position: Vector2(game.size.x - 115, 60),
      size: Vector2.all(32),
      anchor: Anchor.center,
    );
    add(_starComponent);
  }

  @override
  void onGameResize(Vector2 size) {
    _scoreTextComponent.position = Vector2(size.x - 60, 60);
    _starComponent.position = Vector2(game.size.x - 115, 60);
    _deepTextComponent.position = Vector2(game.size.x - 75, 20);
    if (debugInfos) {
      _debugTextComponent.position = Vector2(0, game.size.y - 300);
    }
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = "${game.spaceUsed}/${game.maxSpace}";
    _deepTextComponent.text =
        "${worldManager.getDeep().abs().toStringAsFixed(1)} m";
    _infosTextComponent.text =
        "Health: ${game.health}/${game.maxHealth}\nElectrical power : ${game.electricalPower.toStringAsFixed(1)} kWh";
    if (debugInfos) {
      _debugTextComponent.text =
          "DEBUG\nPos [${worldManager.getPositionInMeter().x.toStringAsFixed(2)},${worldManager.getPositionInMeter().y.toStringAsFixed(2)}]\nChunk ${worldManager.getChunck()}\nFrom origin : [${worldManager.getRelativePositionToZeroZero().x.toStringAsFixed(2)},${worldManager.getRelativePositionToZeroZero().y.toStringAsFixed(2)}]\nFrom ${worldManager.getChunck()} : [${worldManager.getRelativePositionToZeroOfChunck().x.toStringAsFixed(2)},${worldManager.getRelativePositionToZeroOfChunck().y.toStringAsFixed(2)}]";
    }
  }
}
