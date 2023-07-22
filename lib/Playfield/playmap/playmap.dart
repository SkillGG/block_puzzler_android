import 'dart:math' hide log;

import 'package:blockpuzzler/anims/moveanim/moveanimation.dart';
import 'package:blockpuzzler/comps/tile.dart';
import 'package:blockpuzzler/game.dart';
import 'package:blockpuzzler/utils/astar.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

class Playmap extends PositionComponent
    with HasGameRef<BlockPuzzler>, DragCallbacks {
  bool gameOver = false;
  bool _playable = false;

  late RectangleComponent border;

  final Map<Coords, Tile> _tiles;
  late Map<Color, Image> tileImages;

  int _columnNum = 0;
  int _rowNum = 0;
  get cols => _columnNum;
  get rows => _rowNum;

  final (double?, double?) _positionAfterCreation;

  Playmap({(double?, double?)? pos})
      : _tiles = {},
        _positionAfterCreation = pos ?? (null, 0);

  Tile getTileFromInts((int, int) coords) =>
      getTile(Coords(coords.$1, coords.$2));

  Tile getTile(Coords coords) {
    final t = _tiles[coords];
    if (t == null) {
      throw "Tile with coords ${coords.col}/${coords.row} doesn't exist!";
    }
    return t;
  }

  Coords getRandomTileCoords() {
    final x = Random().nextInt(_columnNum);
    final y = Random().nextInt(_rowNum);
    return Coords(x, y);
  }

  Tile getRandomTile() => getTile(getRandomTileCoords());

  List<Tile> get tiles {
    final tileList = <Tile>[];
    for (int col = 0; col < _columnNum; col++) {
      for (int row = 0; row < _rowNum; row++) {
        final t = _tiles[Coords(col, row)];
        if (t != null) tileList.add(t);
      }
    }
    return tileList;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return Rect.fromLTWH(0, 0, size.x, size.y).containsPoint(point);
  }

  createAMap(int w, int h) {
    final tileSize = Vector2(50, 50);
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        var pos = Vector2(i * tileSize.x, j * tileSize.y);
        var tile = Tile(
            id: "tile_$i,$j",
            coords: Coords(i, j),
            color: TileColor.none,
            position: pos,
            size: tileSize);
        _tiles[Coords(i, j)] = tile;
      }
    }
    _columnNum = w;
    _rowNum = h;
    size = Vector2(w * tileSize.x, h * tileSize.y);
    final tile = getRandomTile();
    tile.willBecome = TileColor.green;
    tile.color = TileColor.none;

    getTileFromInts((2, 6)).color = TileColor.blue;
    getTileFromInts((3, 5)).color = TileColor.blue;
    getTileFromInts((3, 6)).color = TileColor.blue;
    getTileFromInts((0, 9)).color = TileColor.blue;

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
    final ma = moveAnimation;
    if (ma != null) ma.updateAnimation(dt);
  }

  void selectTile(Tile t) {
    if (t.color != TileColor.none) {
      selectedTile?.deselect();
      t.select();
      selectedTile = t;
    }
  }

  deselectTile(Tile t) {
    selectedTile?.deselect();
    t.deselect();
    selectedTile = null;
  }

  MoveAnimation? moveAnimation;

  startMoveAnim(void Function() cb, Tile t, AstarPath path) {
    final anim = MoveAnimation(t, () {
      cb();
      moveAnimation = null;
    }, path.map((e) => getTileFromInts(e)).toList());
    anim.play();
    moveAnimation = anim;
  }

  AstarPath? _preMovePath;

  set preMovePath(AstarPath? path) {
    clearPath() {
      // clear path
      _preMovePath?.forEach((coords) {
        final tile = getTileFromInts(coords);
        tile.pathBlock = PathBlock.none;
      });
    }

    if (path == null) {
      clearPath();
      _preMovePath = path;
    } else if (path.isEmpty) {
      clearPath();
      currentTile?.pathBlock = PathBlock.err;
      _preMovePath = path;
    } else {
      clearPath();
      for (var (c, p) in path.toDirectional()) {
        final tile = getTileFromInts(c);
        tile.pathBlock = p;
      }
      _preMovePath = path;
    }
  }

  Tile? selectedTile;
  Tile? currentTile;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (moveAnimation != null) return;
    final draggedOn = componentsAtPoint(event.localPosition);
    for (final t in draggedOn) {
      if (t is Tile) {
        selectTile(t);
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (moveAnimation != null) return;
    final draggedOn = componentsAtPoint(event.localPosition);
    var foundTile = false;
    for (final t in draggedOn) {
      if (t is Tile) {
        foundTile = true;
        if (currentTile != t) {
          final cT = currentTile;
          if (cT != null && cT.pathBlock == PathBlock.err) {
            cT.pathBlock = PathBlock.none;
          }
          currentTile = t;
          final sT = selectedTile;
          if (sT != null && t.color == TileColor.none) {
            preMovePath = getAstarPath(sT, t);
          }
        }
      }
    }
    if (!foundTile) currentTile = null;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (moveAnimation != null) return;
    super.onDragEnd(event);
    final cT = currentTile;
    final sT = selectedTile;
    if (sT != null && cT != null) {
      if (!trySwappingTiles(sT, cT)) {
        cT.pathBlock = PathBlock.none;
      }
      sT.deselect();
    }
  }

  canMoveTo(Tile t1, Tile t2) {
    return getAstarPath(t1, t2).isNotEmpty;
  }

  bool trySwappingTiles(Tile t1, Tile t2) {
    if (t1.color == TileColor.none && t2.color == TileColor.none) return false;
    if (!canMoveTo(t1, t2)) return false;
    final sTile = t1.color == TileColor.none ? t2 : t1;
    var eTile = t1 == sTile ? t2 : t1;
    final prevPath = _preMovePath;
    if (prevPath != null) {
      if (eTile.color != TileColor.none) {
        final lastPathTile = getTileFromInts(prevPath.last);
        if (lastPathTile == sTile) return false;
        eTile = lastPathTile;
      }
      final eTileC = eTile.coords;
      t1.willBecome = TileColor.none;
      t2.willBecome = TileColor.none;
      t1.pathBlock = PathBlock.none;
      t2.pathBlock = PathBlock.none;
      startMoveAnim(() {
        eTile.coords = sTile.coords;
        sTile.coords = eTileC;
        selectedTile = null;
        currentTile = null;
      }, sTile, prevPath);
    }
    _tiles[eTile.coords] = sTile;
    _tiles[sTile.coords] = eTile;
    preMovePath = null;
    return true;
  }

  trySwappingTilesWithSelected(Tile t) {
    if (t.color != TileColor.none) {
      preMovePath = null;
      return;
    }
    final sTile = selectedTile;
    if (sTile != null) {
      preMovePath = getAstarPath(sTile, t);
      if (trySwappingTiles(t, sTile)) {
        deselectTile(sTile);
      }
    }
  }

  void tileTapUp(Tile t) {
    if (moveAnimation != null) return;
    if (!t.isSelected) {
      selectTile(t);
    } else {
      deselectTile(t);
    }
    trySwappingTilesWithSelected(t);
  }

  AstarPath getAstarPath(Tile t1, Tile t2) {
    final grid = Grid(cols: 10, rows: 10);
    final astar = Astar(grid);

    for (Tile tile in tiles) {
      if (tile.color == TileColor.none) continue;
      grid.occupyNode(tile.coords.col, tile.coords.row);
    }

    return astar.search(
        startX: t1.coords.col,
        startY: t1.coords.row,
        endX: t2.coords.col,
        endY: t2.coords.row);
  }
}
