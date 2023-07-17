import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

enum TileColor {
  none(Colors.transparent),
  blue(Colors.blue),
  red(Colors.red),
  yellow(Colors.yellow),
  green(Colors.green);

  final Color c;

  const TileColor(this.c);
}

class Tile extends PositionComponent
    with TapCallbacks, HasGameRef<BlockPuzzler> {
  TileColor _c;

  Sprite? sprite;

  set color(TileColor c) {
    _c = c;
    Image? img = tileImages[_c];
    if (img != null) sprite = Sprite(img);
  }

  TileColor get color => _c;

  static Map<TileColor, Image?> tileImages = {TileColor.none: null};

  Vector2 _padding = Vector2.zero();

  (int, int) coords;

  Tile(
      {TileColor color = TileColor.none,
      required super.size,
      required super.position,
      required this.coords,
      (int, int?)? padding,
      super.priority})
      : _c = TileColor.none {
    this.color = color;
    var pad = padding;
    if (pad != null) {
      var p2 = pad.$2;
      if (p2 == null) {
        _padding = Vector2(pad.$1.toDouble(), pad.$1.toDouble());
      } else {
        _padding = Vector2(pad.$1.toDouble(), p2.toDouble());
      }
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return Rect.fromLTWH(_padding.x, _padding.y, size.x, size.y)
        .containsPoint(point);
  }

  @override
  void render(Canvas canvas) {
    if (_c != TileColor.none) {
      sprite?.render(canvas, position: _padding, size: size);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (color != TileColor.none) {
      gameRef.ui.points++;
      color = TileColor.values[(color.index + 1) % TileColor.values.length];
    }
  }
}
