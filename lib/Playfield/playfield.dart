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
    var list = await Future.wait([
      ("Blue.png", TileColor.blue),
      ("Green.png", TileColor.green),
      ("Red.png", TileColor.red),
      ("Yellow.png", TileColor.yellow)
    ].map((e) async => (e.$2, await Flame.images.load(e.$1))));
    for (var element in list) {
      Tile.tileImages[element.$1] = element.$2;
    }
    map.createAMap(10, 10);
    add(map);
  }
}
