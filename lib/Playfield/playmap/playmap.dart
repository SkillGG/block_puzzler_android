import 'package:blockpuzzler/comps/tile.dart';
import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

class Playmap extends PositionComponent {
  bool gameOver = false;
  bool _playable = false;

  late RectangleComponent border;

  final Map<(int, int), Tile> _tiles;
  late Map<Color, Image> tileImages;

  int _columnNum = 0;
  int _rowNum = 0;
  get cols => _columnNum;
  get rows => _rowNum;

  final (double?, double?) _positionAfterCreation;

  Playmap({(double?, double?)? pos})
      : _tiles = {},
        _positionAfterCreation = pos ?? (null, 0);

  createAMap(int w, int h) {
    final tileSize = Vector2(50, 50);
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        var pos = Vector2(i * tileSize.x, j * tileSize.y);
        var tile = Tile(
            coords: (i, j),
            color: (i + j) % 5 == 0 ? TileColor.blue : TileColor.none,
            position: pos,
            size: tileSize);
        _tiles[(i, j)] = tile;
      }
    }
    _columnNum = w;
    _rowNum = h;
    size = Vector2(w * tileSize.x, h * tileSize.y);

    position.x = _positionAfterCreation.$1 ?? (BlockPuzzler.width - size.x) / 2;
    position.y =
        _positionAfterCreation.$2 ?? (BlockPuzzler.height - size.y) / 2;

    border = RectangleComponent(
        size: size + Vector2(2, 2),
        position: Vector2(-1, -1),
        paint: Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
        priority: 2);

    addAll([..._tiles.values, border]);

    _playable = true;
  }

  @override
  void render(Canvas canvas) {
    if (!_playable) throw ErrorDescription("message");
  }

  @override
  void update(double dt) {
    if (!_playable) return;
  }
}
