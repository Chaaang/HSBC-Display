import 'dart:math';
import 'package:flutter/material.dart';

class MessyNoOverlapRectangles extends StatefulWidget {
  const MessyNoOverlapRectangles({super.key});

  @override
  State<MessyNoOverlapRectangles> createState() =>
      _MessyNoOverlapRectanglesState();
}

class _MessyNoOverlapRectanglesState extends State<MessyNoOverlapRectangles> {
  final Random random = Random();
  final List<Rect> usedRects = [];
  final List<Rect> positions = [];

  @override
  void initState() {
    super.initState();
  }

  void _generatePositions(Size size) {
    const int itemCount = 100;
    const double edgePadding = 10;

    usedRects.clear();
    positions.clear();

    for (int i = 0; i < itemCount; i++) {
      final int rectWidth = 40 + random.nextInt(30); // 40–70 px
      final int rectHeight = 30 + random.nextInt(20); // 30–50 px
      Rect? newRect;
      int attempts = 0;

      do {
        final left =
            edgePadding +
            random.nextDouble() * (size.width - rectWidth - edgePadding * 2);
        final top =
            edgePadding +
            random.nextDouble() * (size.height - rectHeight - edgePadding * 2);
        newRect = Rect.fromLTWH(
          left,
          top,
          rectWidth.toDouble(),
          rectHeight.toDouble(),
        );

        attempts++;
        if (attempts > 1000) break;
      } while (usedRects.any((r) => r.overlaps(newRect!)));

      usedRects.add(newRect);
      positions.add(newRect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (positions.isEmpty) {
            _generatePositions(
              Size(constraints.maxWidth, constraints.maxHeight),
            );
          }

          return Stack(
            children: List.generate(positions.length, (i) {
              final rect = positions[i];
              return Positioned(
                left: rect.left,
                top: rect.top,
                child: Container(
                  width: rect.width,
                  height: rect.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        Colors.primaries[i % Colors.primaries.length].shade400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
