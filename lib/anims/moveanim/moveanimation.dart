import 'dart:ui';

import 'package:blockpuzzler/anims/animation.dart';
import 'package:blockpuzzler/comps/tile.dart';

class MoveAnimation extends LogicAnimation {
  Tile t;

  Coords start;
  Coords end;
  Coords current;

  MoveAnimation(this.t, this.start, this.end) : current = start;

  @override
  render(Canvas canvas) {}

  @override
  update(num time) {}
}
