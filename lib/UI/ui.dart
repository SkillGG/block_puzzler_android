import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class UI extends Component {
  TextComponent pointsText;

  int points = 0;

  UI()
      : pointsText = TextComponent(
            text: "abcdef",
            anchor: Anchor.topRight,
            position: BlockPuzzler.topRight + Vector2(-15, 10),
            textRenderer: TextPaint(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16 * 1.3,
                    fontFamily: "Verdana"))) {
    add(pointsText);
  }

  @override
  void update(double dt) {
    pointsText.text = "Points: $points";
  }
}
