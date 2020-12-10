import 'package:flutter/material.dart';

// Yeeted from https://stackoverflow.com/a/51384111
class AnimatedValue extends ImplicitlyAnimatedWidget {
  final double value;
  final Function builder;

  AnimatedValue({
    Key key,
    @required this.value,
    @required this.builder,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.linear
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _AnimatedValueState();
}

class _AnimatedValueState extends AnimatedWidgetBaseState<AnimatedValue> {
  Tween _value;

  @override
  Widget build(BuildContext context) {
    return widget.builder(_value.evaluate(animation));
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _value = visitor(_value, widget.value, (dynamic value) => new Tween(begin: value));
  }
}