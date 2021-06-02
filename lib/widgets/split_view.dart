import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart' as sv;

class SplitView extends StatelessWidget {
  final Widget first;
  final Widget second;
  final double ratio;
  final Axis axis;
  final Widget? firstTitle;
  final Widget? secondTitle;

  const SplitView({
    Key? key,
    required this.first,
    required this.second,
    this.ratio = 0.5,
    this.axis = Axis.horizontal,
    this.firstTitle,
    this.secondTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sv.SplitView(
      viewMode: _axisToViewMode(axis),
      gripSize: 2,
      controller: sv.SplitViewController(
        weights: [ratio, 1 - ratio],
      ),
      children: [
        first,
        second,
      ],
    );
  }

  sv.SplitViewMode _axisToViewMode(Axis axis) {
    return axis == Axis.horizontal
        ? sv.SplitViewMode.Horizontal
        : sv.SplitViewMode.Vertical;
  }
}
