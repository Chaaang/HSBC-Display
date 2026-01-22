import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/signature_url.dart';

class RandomSignatureScreen extends StatefulWidget {
  final List<SignatureUrl> signatures;
  final String background;
  final int fadeInSec;
  final int freezeInSec;

  const RandomSignatureScreen({
    super.key,
    required this.signatures,
    required this.background,
    required this.fadeInSec,
    required this.freezeInSec,
  });

  @override
  State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
}

class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
  final Random _random = Random();
  late List<SignatureUrl> _currentSignatures;
  late List<bool> _visibleSignatures;
  late List<_Spot> _spots;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    _currentSignatures = [];
    _visibleSignatures = [];
    _spots = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setupAndAnimate();
      }
    });
  }

  void _setupAndAnimate() {
    final size = MediaQuery.of(context).size;
    _computeSpots(size);
    print('🔥 Raw JSON length: ${widget.signatures.length}');
    for (var i = 0; i < widget.signatures.length; i++) {
      print('${i + 1}. ${widget.signatures[i].filename}');
    }
    _prepareNextSet();
    print('Signatures from JSON: ${widget.signatures.length}');
    print('Spots computed: ${_spots.length}');
    print('Displaying: ${_currentSignatures.length}');

    _animateSignaturesSequentially();
  }

  // void _computeSpots(Size size) {
  //   final safeMargin = 40.0;
  //   final placedRects = <Rect>[];
  //   _spots = [];

  //   // dynamically change how many to display (set 5 for testing)
  //   final maxDisplay = min(widget.signatures.length, 100); // <-- test with 5
  //   final maxAttempts = 5000;
  //   int attempts = 0;

  //   while (_spots.length < maxDisplay && attempts < maxAttempts) {
  //     attempts++;

  //     // make size proportional to how many we want to display
  //     final w =
  //         (size.width / sqrt(maxDisplay)) * (0.6 + _random.nextDouble() * 0.4);
  //     final h =
  //         (size.height / sqrt(maxDisplay)) * (0.6 + _random.nextDouble() * 0.4);

  //     final dx =
  //         safeMargin + _random.nextDouble() * (size.width - w - safeMargin * 2);
  //     final dy =
  //         safeMargin +
  //         _random.nextDouble() * (size.height - h - safeMargin * 2);

  //     final rect = Rect.fromLTWH(dx, dy, w, h);

  //     if (placedRects.any((r) => r.overlaps(rect.inflate(4)))) {
  //       continue;
  //     }

  //     placedRects.add(rect);

  //     final rotation = (_random.nextDouble() * 40 - 20) * (pi / 180);

  //     _spots.add(_Spot(Offset(dx, dy), w, h, rotation));
  //   }
  // }

  void _computeSpots(Size size) {
    final safeMargin = 50.0;
    final placedRects = <Rect>[];
    _spots = [];

    final maxDisplay = min(widget.signatures.length, 100);
    final maxAttempts = 5000;
    int attempts = 0;

    double scale = 1.0; // start full size
    int success = 0;

    while (success < maxDisplay && scale > 0.1) {
      placedRects.clear();
      _spots.clear();
      attempts = 0;

      while (_spots.length < maxDisplay && attempts < maxAttempts) {
        attempts++;

        // final w = (size.width / sqrt(maxDisplay)) * 0.9 * scale;
        // final h = (size.height / sqrt(maxDisplay)) * 0.9 * scale;

        final w =
            (size.width / sqrt(maxDisplay)) *
            (0.8 + _random.nextDouble() * 0.4) *
            scale;
        final h =
            (size.height / sqrt(maxDisplay)) *
            (0.8 + _random.nextDouble() * 0.4) *
            scale;

        final dx =
            safeMargin +
            _random.nextDouble() * (size.width - w - safeMargin * 2);
        final dy =
            safeMargin +
            _random.nextDouble() * (size.height - h - safeMargin * 2);

        final rect = Rect.fromLTWH(dx, dy, w, h);

        if (placedRects.any((r) => r.overlaps(rect.inflate(4)))) continue;

        placedRects.add(rect);
        final rotation = (_random.nextDouble() * 40 - 20) * (pi / 180);
        _spots.add(_Spot(Offset(dx, dy), w, h, rotation));
      }

      success = _spots.length;

      // If not all fit, reduce size and try again
      if (success < maxDisplay) {
        scale -= 0.1;
      }
    }

    print('📍 Computed ${_spots.length} spots (scale: $scale)');
  }

  // void _prepareNextSet() {
  //   final n = min(widget.signatures.length, _spots.length);

  //   // Always prioritize the last 20 (or fewer if not enough signatures)
  //   final recent =
  //       widget.signatures.length >= 20
  //           ? widget.signatures.sublist(widget.signatures.length - 20)
  //           : widget.signatures;

  //   // Shuffle the older ones
  //   final older = List<SignatureUrl>.from(
  //     widget.signatures.take(widget.signatures.length - recent.length),
  //   )..shuffle(_random);

  //   // Combine recent + random older, then trim to n
  //   _currentSignatures = [...recent, ...older].take(n).toList();

  //   // Sync visibility list with signature count
  //   _visibleSignatures = List.filled(_currentSignatures.length, false);

  //   // 🧩 Add these prints here
  //   print('🖼️ Displaying ${_currentSignatures.length} images.');
  //   final uniqueNames = _currentSignatures.map((e) => e.filename).toSet();
  //   print('🧮 Unique filenames: ${uniqueNames.length}');
  //   if (uniqueNames.length != _currentSignatures.length) {
  //     print('⚠️ Duplicate filenames detected!');
  //   }

  //   for (final sig in _currentSignatures) {
  //     print('   - ${sig.filename}');
  //   }
  // }

  void _prepareNextSet() {
    if (_spots.isEmpty) {
      print('⚠️ No spots yet — skipping _prepareNextSet');
      return;
    }

    final n = min(widget.signatures.length, _spots.length);

    // Always prioritize the last 20 (or fewer if not enough signatures)
    final recent =
        widget.signatures.length >= 20
            ? widget.signatures.sublist(widget.signatures.length - 20)
            : widget.signatures;

    // Shuffle the older ones
    final older = List<SignatureUrl>.from(
      widget.signatures.take(widget.signatures.length - recent.length),
    )..shuffle(_random);

    // Combine recent + random older, then trim to n
    _currentSignatures = [...recent, ...older].take(n).toList();
    _visibleSignatures = List.filled(_currentSignatures.length, false);

    // 🧩 Printing section (for debug)
    print(
      '\n🖼️ Displaying ${_currentSignatures.length} images '
      '(of total ${widget.signatures.length})',
    );
    print(
      '🧮 Unique filenames: ${_currentSignatures.map((e) => e.filename).toSet().length}',
    );
    for (int i = 0; i < _currentSignatures.length; i++) {
      print('   ${i + 1}. ${_currentSignatures[i].filename}');
    }
  }

  Future<void> _animateSignaturesSequentially() async {
    final indices = List.generate(_visibleSignatures.length, (i) => i)
      ..shuffle(_random);

    // Fade in one by one
    for (final i in indices) {
      if (!mounted) return;
      await Future.delayed(Duration(seconds: widget.fadeInSec));
      setState(() => _visibleSignatures[i] = true);
    }

    // Show all for 10 seconds
    await Future.delayed(Duration(seconds: widget.freezeInSec));
    if (!mounted) return;

    // Fade out all at once
    setState(() {
      for (int i = 0; i < _visibleSignatures.length; i++) {
        _visibleSignatures[i] = false;
      }
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Shuffle again and restart
    final size = MediaQuery.of(context).size;
    _computeSpots(size);
    _prepareNextSet();
    await _animateSignaturesSequentially();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              child:
                  widget.background.isNotEmpty
                      ? Image.network(
                        'https://sign.onecodephoto.com/${widget.background}',
                        fit: BoxFit.cover,
                      )
                      : const SizedBox.shrink(),
            ),
            ...List.generate(min(_visibleSignatures.length, _spots.length), (
              index,
            ) {
              final spot = _spots[index];
              final sig = _currentSignatures[index];

              return AnimatedPositioned(
                duration:
                    firstBuild
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                //duration: const Duration(milliseconds: 300),
                left: spot.pos.dx,
                top: spot.pos.dy,
                width: spot.width,
                height: spot.height,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _visibleSignatures[index] ? 1.0 : 0.0,
                  child: Transform.rotate(
                    angle: spot.rotation,
                    child: Image.network(
                      'https://sign.onecodephoto.com${sig.filename}',
                      fit: BoxFit.fill,
                      errorBuilder:
                          (_, __, ___) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _Spot {
  final Offset pos;
  final double width;
  final double height;
  final double rotation;

  _Spot(this.pos, this.width, this.height, this.rotation);
}
