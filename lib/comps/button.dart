import 'package:blockpuzzler/comps/label.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

class Button extends PositionComponent with TapCallbacks {
  Label label;

  final Vector2? sPos;

  Button(
      {required super.position,
      super.anchor,
      required super.size,
      this.onup,
      this.ondown,
      this.oncancel,
      String? label,
      required LabelOptions labelOptions})
      : label = Label(size: size, options: labelOptions, text: label ?? ""),
        sPos = position {
    add(this.label);
  }

  void Function()? onup;

  void Function()? ondown;
  void Function()? oncancel;

  @override
  bool containsLocalPoint(Vector2 point) {
    return Rect.fromLTWH(0, 0, size.x, size.y).containsPoint(point);
  }

  @override
  void render(Canvas canvas) {}

  @override
  void update(double dt) {}

  @override
  void onTapDown(TapDownEvent event) {
    ondown?.call();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    oncancel?.call();
  }

  @override
  void onTapUp(TapUpEvent event) {
    onup?.call();
  }
}
