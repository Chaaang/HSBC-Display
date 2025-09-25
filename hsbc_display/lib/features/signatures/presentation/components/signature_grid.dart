import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../domain/entities/signature_url.dart';

class RandomSignatureScreen extends StatefulWidget {
  final List<SignatureUrl> signatures;
  final String background;

  const RandomSignatureScreen({
    super.key,
    required this.signatures,
    required this.background,
  });

  @override
  State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
}

class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
  final Random _random = Random();
  late List<bool> _visibleList;
  late List<Offset> _positions;

  final double _sigWidth = 250;
  final double _sigHeight = 250;
  final double _padding = 12;
  final double _minDistance = 60;

  @override
  void initState() {
    super.initState();
    _resetState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _placeSignaturesRandomly();
      _animateSignaturesSequentially();
    });
  }

  @override
  void didUpdateWidget(covariant RandomSignatureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.signatures.length != oldWidget.signatures.length ||
        widget.background != oldWidget.background) {
      _resetState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _placeSignaturesRandomly();
        _animateSignaturesSequentially();
      });
    }
  }

  void _resetState() {
    _visibleList = List<bool>.filled(widget.signatures.length, false);
    _positions = List<Offset>.filled(widget.signatures.length, Offset.zero);
  }

  void _placeSignaturesRandomly() {
    final size = MediaQuery.of(context).size;
    bool success = false;
    int attempts = 0;

    double sigWidth = _sigWidth;
    double sigHeight = _sigHeight;
    double minDistance = _minDistance;

    if (widget.signatures.length > 20) {
      sigWidth *= 0.85;
      sigHeight *= 0.85;
      minDistance = 50;
    }
    if (widget.signatures.length > 40) {
      sigWidth *= 0.85;
      sigHeight *= 0.85;
      minDistance = 30;
    }

    double totalWidth = sigWidth + _padding * 2;
    double totalHeight = sigHeight + _padding * 2;

    while (!success && attempts < 1000) {
      attempts++;
      List<Offset> tempPositions = [];
      bool failed = false;

      for (int i = 0; i < widget.signatures.length; i++) {
        Offset pos;
        int tries = 0;

        do {
          pos = Offset(
            8 + _random.nextDouble() * (size.width - totalWidth - 8),
            8 + _random.nextDouble() * (size.height - totalHeight - 8),
          );

          bool overlaps = tempPositions.any(
            (existing) => (existing - pos).distance < minDistance,
          );

          if (!overlaps) break;

          tries++;
          if (tries > 100) {
            failed = true;
            break;
          }
        } while (true);

        if (failed) break;
        tempPositions.add(pos);
      }

      if (!failed) {
        _positions = tempPositions;
        success = true;
      }
    }

    if (!success) {
      _positions = List.generate(
        widget.signatures.length,
        (_) => Offset(
          8 + _random.nextDouble() * (size.width - totalWidth - 8),
          8 + _random.nextDouble() * (size.height - totalHeight - 8),
        ),
      );
    }

    setState(() {
      _visibleList = List<bool>.filled(widget.signatures.length, false);
    });
  }

  // Sequential animation to prevent overlap
  void _animateSignaturesSequentially() async {
    for (int i = 0; i < widget.signatures.length; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _visibleList[i] = true;
      });
    }

    // Once all visible, reshuffle after delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _placeSignaturesRandomly();
    _visibleList = List<bool>.filled(widget.signatures.length, false);
    _animateSignaturesSequentially();
  }

  @override
  Widget build(BuildContext context) {
    double sigWidth = _sigWidth;
    double sigHeight = _sigHeight;
    if (widget.signatures.length > 20) {
      sigWidth *= 0.85;
      sigHeight *= 0.85;
    }
    if (widget.signatures.length > 40) {
      sigWidth *= 0.85;
      sigHeight *= 0.85;
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://sign.onecodephoto.com/${widget.background}',
              fit: BoxFit.cover,
            ),
          ),
          ...List.generate(widget.signatures.length, (index) {
            final sig = widget.signatures[index];
            final pos = _positions[index];
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: pos.dx,
              top: pos.dy,
              width: sigWidth,
              height: sigHeight,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _visibleList[index] ? 1.0 : 0.0,
                child: Image.network(
                  'https://sign.onecodephoto.com${sig.filename}',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
