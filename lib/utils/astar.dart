library astar;

import 'dart:math';

import 'package:blockpuzzler/comps/tile.dart';
import 'package:flutter/foundation.dart';

part 'astar_paths.dart';

class Node {
  int x;
  int y;
  double g = 0;
  double f = 0;
  double? h;

  bool _occupied = false;

  String? type;
  (int, int)? parent;

  (int, int) key;

//        this.x = x;
  // this.y = y;
  // this.g = 0;
  // this.f = 0;
  // this.key = keyFromArray([x, y]);
  Node(this.x, this.y) : key = (x, y);

  isOccupied() => _occupied;
  isEmpty() => !_occupied;
  emptyNode() => _occupied = false;
  occupyNode() => _occupied = true;
}

class Grid {
  List<List<Node>> nodes = [];
  int cols;
  int rows;

  Grid({required this.cols, required this.rows}) {
    for (int i = 0; i < rows; i++) {
      final List<Node> rows = [];
      for (int j = 0; j < cols; j++) {
        rows.add(Node(i, j));
      }
      nodes.add(rows);
    }
  }
  Node getNode(int x, int y) {
    return nodes[x][y];
  }

  printNodes() {
    var i = 0;
    for (var row in nodes) {
      if (kDebugMode) {
        print("row#${i++} ${row.map((n) => n.isOccupied()).join(",")}");
      }
    }
  }

  occupyNode(int x, int y) {
    getNode(x, y).occupyNode();
  }

  emptyNode(int x, int y) => getNode(x, y).emptyNode();
}

class Astar {
  Grid grid;
  Set<(int, int)> openList;
  Set<(int, int)> closedList;

  Astar(this.grid)
      : openList = {},
        closedList = {};

  (int, int)? startCoords;
  (int, int)? endCoords;

  AstarPath search(
      {required int startX,
      required int startY,
      required int endX,
      required int endY}) {
    final sCoords = (startX, startY);
    final eCoords = (endX, endY);

    startCoords = sCoords;
    endCoords = eCoords;

    grid.emptyNode(startX, startY);
    grid.emptyNode(endX, endY);

    AstarPath result = AstarPath();

    bool canContinue = true;

    searchFn((int, int) coords) {
      if (grid.getNode(coords.$1, coords.$2) == grid.getNode(endX, endY)) {
        canContinue = false;
        result = reconstructPath(coords);
      } else {
        var neighbours = getNeighbours(coords);

        for (var neighbour in neighbours) {
          final neighbourNode = grid.getNode(neighbour.$1, neighbour.$2);
          if (!openList.contains(neighbour)) {
            openList.add(neighbour);
            neighbourNode.parent = coords;
            final double newG = g(neighbour, coords);
            final double newH = h(neighbour, eCoords);
            neighbourNode.g = newG;
            neighbourNode.h = newH;
            neighbourNode.f = newG + newH;
          } else {
            final double oldG = neighbourNode.g;
            final double newG = g(neighbour, coords);
            if (newG < oldG) {
              neighbourNode.parent = coords;
              neighbourNode.g = newG;
              neighbourNode.f = f(neighbour);
            }
          }
        }
        openList.remove(coords);
        closedList.add(coords);
      }
    }

    searchFn((startX, startY));

    while (canContinue) {
      final Node? minItem = getMinimumFromOpenNodes();
      if (minItem != null) {
        searchFn(minItem.key);
      } else {
        canContinue = false;
      }
    }
    return result;
  }

  AstarPath reconstructPath((int, int) coords) {
    (int, int) backCoords = coords;
    AstarPath result = AstarPath();
    result.add(coords);
    bool isLoop = true;
    while (isLoop) {
      final node = grid.getNode(backCoords.$1, backCoords.$2);
      final parentCoords = node.parent;
      if (parentCoords != null) {
        result.insert(0, parentCoords);
        backCoords = parentCoords;
      } else {
        isLoop = false;
      }
    }
    return result;
  }

  getMinimumFromOpenNodes() {
    Node? retNode;
    for ((int, int) coords in openList) {
      final node = grid.getNode(coords.$1, coords.$2);
      if (retNode == null || node.f < retNode.f) {
        retNode = node;
      }
    }
    return retNode;
  }

  List<(int, int)> getNeighbours((int, int) coords) {
    List<(int, int)> result = [];
    List<(int, int)> offsets = [
      (0, -1),
      (1, 0),
      (0, 1),
      (-1, 0),
    ];
    for (var offset in offsets) {
      (int, int) newXY = (coords.$1 + offset.$1, coords.$2 + offset.$2);
      bool isClosed = closedList.contains(newXY);

      if (newXY.$1 > -1 &&
          newXY.$1 < grid.cols &&
          newXY.$2 > -1 &&
          newXY.$2 < grid.rows) {
        var node = grid.getNode(newXY.$1, newXY.$2);
        if (!isClosed && node.isEmpty()) {
          result.add(newXY);
        }
      }
    }
    return result;
  }

  double f((int, int) coords) {
    final node = grid.getNode(coords.$1, coords.$2);
    return (node.g + (node.h ?? 0)).toDouble();
  }

  double g((int, int) coords, (int, int) parentCoords) {
    return ((parentCoords.$1 == coords.$1 || parentCoords.$1 == coords.$1
                ? 10
                : 14) +
            grid.getNode(parentCoords.$1, parentCoords.$2).g)
        .toDouble();
  }

  double h((int, int) start, (int, int) end) {
    return (((start.$1 - end.$1).abs() + (start.$2 - end.$2).abs()) * 10)
        .toDouble();
  }
}
