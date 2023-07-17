import 'package:blockpuzzler/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LabelOptions {
  Color borderColor;
  double borderWidth;
  Color bgColor;
  TextStyle textStyle;

  LabelOptions.copy(LabelOptions o)
      : borderColor = o.borderColor,
        borderWidth = o.borderWidth,
        bgColor = o.bgColor,
        textStyle = o.textStyle;

  LabelOptions(
      {this.textStyle = const TextStyle(),
      this.borderColor = Colors.black,
      this.borderWidth = 1,
      this.bgColor = Colors.transparent});

  @override
  String toString() {
    return "$borderColor, $bgColor";
  }
}

class Label extends PositionComponent with Alignable {
  LabelOptions _options;
  RectangleComponent border;
  TextComponent textComp;

  String text;

  Vector2 _pos = Vector2(0, 0);

  Vector2 get pos => _pos;

  LabelOptions? _savedOptions;

  saveStyles() {
    _savedOptions = LabelOptions.copy(_options);
  }

  restoreStyles() {
    _options = _savedOptions ?? _options;
    _applyStyles();
  }

  set textStyle(TextStyle c) {
    _options.textStyle = c;
    _applyStyles();
  }

  set borderWidth(double c) {
    _options.borderWidth = c;
    _applyStyles();
  }

  set borderColor(Color c) {
    _options.borderColor = c;
    _applyStyles();
  }

  set bgColor(Color c) {
    _options.bgColor = c;
    _applyStyles();
  }

  set options(LabelOptions o) {
    _options = o;
    _applyStyles();
  }

  _applyStyles() {
    border.paintLayers = [
      Paint()
        ..color = _options.bgColor
        ..style = PaintingStyle.fill,
      Paint()
        ..color = _options.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _options.borderWidth
    ];
    textComp.textRenderer = TextPaint(style: _options.textStyle);
  }

  set align(ObjectAlign x) {
    setAlign(x);
    final (p, a) = getAlignment();
    textComp.position = p;
    textComp.anchor = a;
  }

  set pos(Vector2 v) {
    _pos = v;
    position = pos;
    final (p, a) = getAlignment();
    textComp.position = p;
    textComp.anchor = a;
  }

  Label(
      {Vector2? position,
      required super.size,
      required this.text,
      required LabelOptions options,
      ObjectAlign? vhAlign,
      super.anchor})
      : _options = options,
        border = RectangleComponent(
          size: size,
          anchor: Anchor.topLeft,
        ),
        textComp = TextComponent(
          text: text,
        ) {
    pos = position ?? pos;
    align = vhAlign ?? align;
    textComp.textRenderer = TextPaint(style: _options.textStyle);
    _applyStyles();
    addAll([border, textComp]);
  }

  @override
  void update(double dt) {
    textComp.text = text;
  }
}
