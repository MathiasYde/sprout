import 'package:flutter/material.dart';

class SeperateBuilder extends StatelessWidget {
  final int itemCount;
  final Function itemBuilder;
  final Function separatorBuilder;

  SeperateBuilder({this.itemCount, this.itemBuilder, this.separatorBuilder});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();

    for (int i = 0; i < itemCount; ++i) {
      children.add(itemBuilder(context, i));
      if (i < itemCount - 1)
        children.add(separatorBuilder(context, i));
    }

    return Column(
      children: children,
    );
  }
}