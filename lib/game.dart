import 'dart:async';
import 'package:blockpuzzler/Playfield/playfield.dart';
import 'package:blockpuzzler/UI/ui.dart';
import 'package:blockpuzzler/menu/menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;

class BlockPuzzler extends FlameGame {
  BlockPuzzler() : super();

  final world = World();
  late final CameraComponent cameraComponent;

  static double get width => 600;
  static double get height => 900;

  static Vector2 get topLeft => Vector2.zero();
  static Vector2 get centerLeft => Vector2(0, height / 2);
  static Vector2 get bottomLeft => Vector2(0, height);
  static Vector2 get topRight => Vector2(width, 0);
  static Vector2 get centerRight => Vector2(width, height / 2);
  static Vector2 get bottomRight => Vector2(width, height);
  static Vector2 get topCenter => Vector2(width / 2, 0);
  static Vector2 get center => Vector2(width / 2, height / 2);
  static Vector2 get bottomCenter => Vector2(width / 2, height);

  late final RouterComponent router;

  Playfield get playfield =>
      (router.routes["game"] as PlayfieldRoute).playfield;

  UI get ui => (router.routes["game"] as PlayfieldRoute).ui;

  MainMenu get menu =>
      (router.routes["menu"]?.firstChild()?.firstChild()) as MainMenu;

  @override
  Color backgroundColor() => const Color(0x99cccccc);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    cameraComponent = CameraComponent.withFixedResolution(
        world: world, width: width, height: height);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([world, cameraComponent]);

    world.add(router = RouterComponent(
        routes: {"menu": Route(MainMenu.new), "game": PlayfieldRoute()},
        initialRoute: "menu"));
  }
}
