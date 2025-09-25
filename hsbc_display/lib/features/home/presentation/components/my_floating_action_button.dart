import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final String herotag;
  final String toolTip;
  final void Function() onTap;
  final Widget widget;
  const MyFloatingActionButton({
    super.key,
    required this.herotag,
    required this.toolTip,
    required this.onTap,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      onPressed: onTap,
      heroTag: herotag,
      tooltip: toolTip,
      child: widget,
    );
  }
}
