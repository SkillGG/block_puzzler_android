import 'dart:async';

import 'package:blockpuzzler/Playfield/playmap/playmap.dart';
import 'package:blockpuzzler/comps/tile.dart';
import 'package:blockpuzzler/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class PlayfieldRoute extends Route with HasGameRef<BlockPuzzler> {
  PlayfieldRoute() : super(Playfield.new);

  Playfield get playfield => firstChild() as Playfield;
}

class Playfield extends Component with HasGameRef<BlockPuzzler> {
  Playmap map;
  Playfield({super.key}) : map = Playmap(pos: (null, 75));

  @override
  FutureOr<void> onLoad() async {
    var tileColorSprites = await Future.wait([
      ("Tiles/Blue.png", TileColor.blue),
      ("Tiles/Green.png", TileColor.green),
      ("Tiles/Red.png", TileColor.red),
      ("Tiles/Yellow.png", TileColor.yellow)
    ].map((e) async => (e.$2, await Flame.images.load(e.$1))));
    var pathSprites = await Future.wait([
      ("Paths/lb.png", PathBlock.lb),
      ("Paths/lt.png", PathBlock.lt),
      ("Paths/rb.png", PathBlock.rb),
      ("Paths/rt.png", PathBlock.rt),
      ("Paths/end.png", PathBlock.end),
      ("Paths/err.png", PathBlock.err),
      ("Paths/horizontal.png", PathBlock.horizontal),
      ("Paths/vertical.png", PathBlock.vertical)
    ].map((e) async => (e.$2, await Flame.images.load(e.$1))));
    for (var (color, img) in tileColorSprites) {
      Tile.tileImages[color] = img;
    }
    for (var (pb, img) in pathSprites) {
      Tile.pathImages[pb] = img;
    }
    map.createAMap(10, 10);
    add(map);
  }
}
