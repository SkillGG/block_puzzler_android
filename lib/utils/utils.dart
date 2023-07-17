import 'package:flame/components.dart';

enum ObjectAlign {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomRight,
  bottomCenter
}

mixin Alignable implements PositionComponent {
  ObjectAlign _align = ObjectAlign.center;

  ObjectAlign get align => _align;

  setAlign(ObjectAlign a) {
    _align = a;
  }

  (Vector2, Anchor) getAlignment() {
    switch (_align) {
      case (ObjectAlign.topLeft):
        return (Vector2.zero(), Anchor.topLeft);
      case (ObjectAlign.topCenter):
        return (Vector2(size.x / 2, 0), Anchor.topCenter);
      case (ObjectAlign.topRight):
        return (Vector2(size.x, 0), Anchor.topRight);
      case (ObjectAlign.centerLeft):
        return (Vector2(0, size.y / 2), Anchor.centerLeft);
      case (ObjectAlign.centerRight):
        return (Vector2(size.x, size.y / 2), Anchor.centerRight);
      case (ObjectAlign.bottomLeft):
        return (Vector2(0, size.y), Anchor.bottomLeft);
      case (ObjectAlign.bottomCenter):
        return (Vector2(size.x / 2, size.y), Anchor.bottomCenter);
      case (ObjectAlign.bottomRight):
        return (Vector2(size.x, size.y), Anchor.bottomRight);
      case (ObjectAlign.center):
      default:
        return (Vector2(size.x / 2, size.y / 2), Anchor.center);
    }
  }
}
