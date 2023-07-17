import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class UI extends Component with HasGameRef<BlockPuzzler> {
  TextComponent pointsText;
  TextComponent versionText;

  FpsComponent fpsCounter;
  TextComponent fpsText;

  int points = 0;

  UI()
      : pointsText = TextComponent(
            anchor: Anchor.topRight,
            position: BlockPuzzler.topRight + Vector2(-15, 10),
            textRenderer: TextPaint(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 1.3 * em,
                    fontFamily: "Verdana"))),
        versionText = TextComponent(
            text: "Version: ${BlockPuzzler.version}",
            position: BlockPuzzler.topLeft + Vector2(5, 5),
            textRenderer: TextPaint(
                style:
                    const TextStyle(color: Colors.black, fontSize: 0.8 * em))),
        fpsCounter = FpsComponent(windowSize: 120),
        fpsText = TextComponent(
            position: BlockPuzzler.topLeft + Vector2(5, em + 5 + 2),
            textRenderer: TextPaint(
                style:
                    const TextStyle(fontSize: 0.8 * em, color: Colors.black))) {
    addAll([pointsText, versionText, fpsCounter, fpsText]);
  }

  @override
  void update(double dt) {
    if (gameRef.state == GameState.menu) {
      pointsText.text = "";
    } else if (gameRef.state == GameState.game) {
      pointsText.text = "Points: $points";
    }
    fpsText.text = "FPS: ${fpsCounter.fps.round()}";
  }
}
