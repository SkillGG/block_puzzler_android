import 'dart:async';

import 'package:blockpuzzler/comps/button.dart';
import 'package:blockpuzzler/comps/label.dart';
import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MainMenu extends Component with TapCallbacks, HasGameRef<BlockPuzzler> {
  late Button startButton;
  late Label menuLabel;

  static int tapper = 0;

  @override
  FutureOr<void> onLoad() {
    menuLabel = Label(
        position: BlockPuzzler.topCenter + Vector2(0, 2 * em + 20),
        anchor: Anchor.center,
        size: Vector2(0, 0),
        text: "Block Puzzler",
        options: LabelOptions(
            borderColor: Colors.transparent,
            textStyle: const TextStyle(
                fontSize: 16 * 1.5,
                color: Colors.black,
                fontFamily: "Lumanosimo")));
    startButton = Button(
        position: BlockPuzzler.center - Vector2(50, 225),
        size: Vector2(100, 50),
        onup: () {
          gameRef.state = GameState.game;
          startButton.label.restoreStyles();
        },
        ondown: () {
          startButton.label.saveStyles();
          startButton.label.bgColor = Colors.blue;
          startButton.label.borderWidth = 3;
        },
        oncancel: () {
          startButton.label.restoreStyles();
        },
        label: "START",
        labelOptions: LabelOptions(
            borderColor: Colors.black,
            textStyle:
                const TextStyle(color: Colors.black, fontSize: 16 * 1.6)));
    addAll([startButton, menuLabel]);
  }

  @override
  void update(double dt) {}
}
