import 'package:blockpuzzler/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';

PackageInfo? packageInfo;

class GameSettings {
  static const debugShowTileId = false;
  static bool debugShowPathLines = false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  runApp(GameWidget(game: BlockPuzzler()));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}
