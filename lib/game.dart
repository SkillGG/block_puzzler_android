import 'dart:async';
import 'package:blockpuzzler/Playfield/playfield.dart';
import 'package:blockpuzzler/UI/ui.dart';
import 'package:blockpuzzler/main.dart';
import 'package:blockpuzzler/menu/menu.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;

const int em = 16;

enum GameState {
  game("game"),
  menu("menu");

  const GameState(String s) : rootName = s;
  final String rootName;
}

class BlockPuzzler extends FlameGame {
  BlockPuzzler()
      : _ui = UI(),
        _pr = PlayfieldRoute(),
        _menu = MainMenu(),
        super();

  final world = World();
  late final CameraComponent cameraComponent;

  static double get width => 600;
  static double get height => 900;

  static String version = packageInfo?.version ?? "0";

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

  GameState _state = GameState.menu;

  GameState get state => _state;

  set state(GameState gs) {
    router.pushReplacementNamed(gs.rootName);
    _state = gs;
  }

  final UI _ui;
  final PlayfieldRoute _pr;
  final MainMenu _menu;

  UI get ui => _ui;
  Playfield get playfield => _pr.playfield;
  MainMenu get menu => _menu;

  @override
  Color backgroundColor() => const Color(0x99cccccc);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    cameraComponent = CameraComponent(
        world: world,
        viewport: FixedAspectRatioViewport(aspectRatio: width / height)
          ..anchor = Anchor.topLeft,
        viewfinder: Viewfinder()
          ..visibleGameSize = Vector2(width, height)
          ..anchor = Anchor.topLeft);
    addAll([world, cameraComponent]);

    world.add(_ui);

    world.add(router = RouterComponent(routes: {
      GameState.menu.rootName: Route(() => _menu),
      GameState.game.rootName: _pr
    }, initialRoute: "menu"));
  }

  bool first = false;

  @override
  void update(double dt) {
    super.update(dt);
    cameraComponent.viewport.position = Vector2(0, 0);
  }
}
