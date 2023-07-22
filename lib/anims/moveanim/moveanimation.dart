import 'package:blockpuzzler/anims/animation.dart';
import 'package:blockpuzzler/comps/tile.dart';
import 'package:blockpuzzler/main.dart';
import 'package:flame/extensions.dart';

class PathLine {
  final Vector2 start;
  final Vector2 end;
  late double distance;
  late double _direction;
  late bool _isHoriz;
  PathLine(this.start, this.end) {
    _isHoriz = start[1] == end[1];
    _direction = _isHoriz ? (end[0] - start[0]).sign : (end[1] - start[1]).sign;
    distance = _isHoriz ? (end[0] - start[0]).abs() : (end[1] - start[1]).abs();
  }
  Vector2 getDistancedPos(double d) {
    if (_isHoriz) {
      return Vector2(start[0] + -d * _direction, end[1]);
    }
    return Vector2(end[0], start[1] + -d * _direction);
  }
}

class MoveAnimation extends LogicAnimation {
  Tile tile;

  List<PathLine> pathLines = [];

  double totalDistance = 0;

  double traveled = 0;
  double blendT = 0;

  MoveAnimation(this.tile, super.finish, List<Tile> path) {
    calcPathLines(path);
    totalDistance = pathDistance(path[0].position);
    if (GameSettings.debugShowPathLines) printLines();
  }

  printLines() {
    for (final line in pathLines) {
      // ignore: avoid_print
      print("${line.start} => ${line.end}");
    }
  }

  calcPathLines(List<Tile> tiles) {
    List<List<Vector2>> lines = [];
    for (final entry in tiles.asMap().entries) {
      final index = entry.key;
      final tile = entry.value;
      final pos = tile.position;
      if (index == 0) {
        lines.add([pos]);
      } else if (tile.pathBlock == PathBlock.horizontal ||
          tile.pathBlock == PathBlock.vertical) {
        if (lines.last.length == 2) {
          lines.last.removeLast();
        }
        lines.last.add(pos);
      } else if (tile.pathBlock == PathBlock.lb ||
          tile.pathBlock == PathBlock.lt ||
          tile.pathBlock == PathBlock.rb ||
          tile.pathBlock == PathBlock.rt) {
        if (lines.last.length == 2) {
          lines.last.removeLast();
        }
        lines.last.add(pos);
        lines.add([pos]);
      } else {
        if (lines.last.length >= 2) lines.last.removeLast();
        lines.last.add(pos);
      }
    }
    pathLines = lines.map((e) => PathLine(e[0], e[1])).toList();
  }

  moveToDistance(double n) {
    double distance = 0;
    for (final line in pathLines) {
      if (n < distance + line.distance) {
        // found;
        final pos = line.getDistancedPos(distance - n);
        tile.offsetXY =
            Vector2(pos[0] - tile.position.x, pos[1] - tile.position.y);
        break;
      }
      distance += line.distance;
    }
  }

  double pathDistance(Vector2 pos) {
    final lineIndex = pathLines.indexWhere((element) {
      final start = element.start;
      final end = element.end;
      final x = pos.x;
      final y = pos.y;
      return ((x > start[0] && x < end[0] && y > start[1] && x < end[1]) ||
          (x == start[0] && y == start[1]));
    });
    if (lineIndex < 0) return 0;

    final linesToGo = pathLines.skip(lineIndex).toList();

    return linesToGo.asMap().entries.fold(0, (previousValue, element) {
      if (element.key == lineIndex) {
        final start = pos;
        final end = element.value.end;
        return PathLine(start, end).distance;
      } else {
        return previousValue + element.value.distance;
      }
    });
  }

  @override
  renderAnimation(Canvas canvas) {}

  @override
  updateAnimation(double time) {
    if (isPlaying()) {
      frame++;
      final dS = (time * 1000);
      traveled += dS;

      if (totalDistance - traveled < 3) traveled = totalDistance;

      moveToDistance(traveled);

      if (traveled >= totalDistance) {
        tile.offsetXY = Vector2.zero();
        finish();
      }
    }
  }
}
