library animations;

import 'dart:ui';
import 'package:flame/extensions.dart';

abstract class LogicAnimation {
  int frame = 0;
  bool _playing = false;
  void Function() finish;
  LogicAnimation(this.finish);
  updateAnimation(double time);
  renderAnimation(Canvas canvas);
  isPlaying() => _playing;
  play() => _playing = true;
  stop() {
    _playing = false;
    finish();
  }
}
