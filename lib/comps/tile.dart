import 'package:blockpuzzler/game.dart';
import 'package:blockpuzzler/main.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

class Coords {
  int col;
  int row;
  Coords(this.col, this.row);

  @override
  int get hashCode => col + row * 100;

  @override
  bool operator ==(Object other) {
    if (other is Coords) {
      return other.col == col && other.row == row;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "$col/$row";
  }
}

enum TileColor {
  none(Colors.transparent),
  blue(Colors.blue),
  red(Colors.red),
  yellow(Colors.yellow),
  green(Colors.green);

  final Color color;

  const TileColor(this.color);
}

enum PathBlock {
  none,
  horizontal,
  vertical,
  end,
  err,
  lt,
  rt,
  lb,
  rb,
}

class Tile extends PositionComponent
    with TapCallbacks, HasGameRef<BlockPuzzler> {
  String id;

  PathBlock _pathBlock = PathBlock.none;
  static Map<PathBlock, Image?> pathImages = {PathBlock.none: null};
  Sprite? pathSprite;
  set pathBlock(PathBlock p) {
    _pathBlock = p;
    Image? img = pathImages[p];
    if (img != null) pathSprite = Sprite(img);
  }

  PathBlock get pathBlock => _pathBlock;

  TileColor _c;
  Sprite? tileSprite;
  static Map<TileColor, Image?> tileImages = {TileColor.none: null};
  set color(TileColor c) {
    _c = c;
    Image? img = tileImages[_c];
    if (img != null) tileSprite = Sprite(img);
  }

  TileColor get color => _c;

  TileColor willBecome = TileColor.none;

  Vector2 _padding = Vector2.zero();

  Coords _coords;

  Coords get coords => _coords;

  set coords(Coords newcoords) {
    _coords = newcoords;
    position = Vector2(newcoords.col * size.x, newcoords.row * size.y);
  }

  Tile(
      {required this.id,
      TileColor color = TileColor.none,
      required super.size,
      required super.position,
      required Coords coords,
      (int, int?)? padding,
      super.priority})
      : _coords = coords,
        _c = TileColor.none {
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
    tr = TextComponent(
        anchor: Anchor.center,
        text: id.replaceAll(RegExp(r'tile_'), ""),
        position: size / 2,
        textRenderer: TextPaint(
            style: const TextStyle(fontSize: 20, color: Colors.black)));
    if (GameSettings.debugShowTileId) add(tr);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return Rect.fromLTWH(_padding.x, _padding.y, size.x, size.y)
        .containsPoint(point);
  }

  late TextComponent tr;

  Vector2 offsetXY = Vector2(0, 0);
  Vector2 offsetSize = Vector2(0, 0);

  @override
  void render(Canvas canvas) {
    if (_c != TileColor.none) {
      tileSprite?.render(canvas,
          position: _padding + offsetXY, size: size + offsetSize);
    }
    if (_selected) {
      // canvas.clipRect(position.toOffset() & size.toSize());
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.x, size.y),
          Paint()
            ..color = const Color.fromARGB(50, 0, 0, 0)
            ..blendMode = BlendMode.darken);
    }
    if (willBecome != TileColor.none) {
      // print("Drawing willBecome $willBecome");
      canvas.drawCircle(
          (size / 2).toOffset(), 6, Paint()..color = willBecome.color);
    }

    if (pathBlock != PathBlock.none) {
      pathSprite?.render(canvas, position: _padding, size: size);
    }
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    if (color != TileColor.none) {
      color = TileColor.values[(color.index + 1) % TileColor.values.length];
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.playfield.map.tileTapUp(this);
  }

  var _selected = false;

  bool get isSelected => _selected;

  select() {
    _selected = true;
  }

  deselect() {
    _selected = false;
  }
}
