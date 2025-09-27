// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots;

//   final double _sigWidth = 100;
//   final double _sigHeight = 100;
//   final int _maxDisplay = 100;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Generate random positions without overlapping
//   void _computeSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 20.0;
//     final placed = <Rect>[];

//     _spots = [];

//     for (int i = 0; i < _maxDisplay; i++) {
//       bool overlap;
//       Offset pos;
//       int tries = 0;

//       do {
//         double dx =
//             padding +
//             _random.nextDouble() * (size.width - _sigWidth - padding * 2);
//         double dy =
//             padding +
//             _random.nextDouble() * (size.height - _sigHeight - padding * 2);

//         pos = Offset(dx, dy);
//         Rect newRect = Rect.fromLTWH(dx, dy, _sigWidth, _sigHeight);

//         overlap = placed.any((r) => r.overlaps(newRect));
//         tries++;
//         if (tries > 50) break; // prevent infinite loop
//       } while (overlap);

//       placed.add(Rect.fromLTWH(pos.dx, pos.dy, _sigWidth, _sigHeight));
//       _spots.add(pos);
//     }
//   }

//   /// Assign images to the spots
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _maxDisplay);

//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();

//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(_visibleSignatures.length, (index) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];
//           final rotation =
//               (_random.nextDouble() * 30 - 15) * pi / 180; // random rotation

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
/////////////////////////////////////////////////////
library;

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots; // absolute positions

//   late double _sigWidth;
//   late double _sigHeight;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSize();
//     _computeSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Dynamically compute signature size to avoid overlaps
//   void _computeImageSize() {
//     final size = MediaQuery.of(context).size;
//     final n = widget.signatures.length.clamp(1, 30); // max 30
//     // Let's assume we want a grid layout with some padding
//     final cols = (sqrt(n)).ceil();
//     final rows = (n / cols).ceil();
//     final padding = 10.0;

//     _sigWidth = (size.width - padding * (cols + 1)) / cols;
//     _sigHeight = (size.height - padding * (rows + 1)) / rows;
//   }

//   /// Generate non-overlapping positions using grid with random offsets
//   void _computeSpots() {
//     final size = MediaQuery.of(context).size;
//     final n = widget.signatures.length.clamp(1, 30);
//     final cols = (sqrt(n)).ceil();
//     final rows = (n / cols).ceil();
//     final padding = 10.0;

//     final placedRects = <Rect>[];
//     _spots = [];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= n) break;

//         double dx = padding + c * (_sigWidth + padding);
//         double dy = padding + r * (_sigHeight + padding);

//         // add small random offset inside the cell
//         dx += _random.nextDouble() * (_sigWidth * 0.2);
//         dy += _random.nextDouble() * (_sigHeight * 0.2);

//         final rect = Rect.fromLTWH(dx, dy, _sigWidth, _sigHeight);

//         // safety check (should never overlap in this grid method)
//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length);
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _prepareNextSet();
//     _computeSpots();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(_visibleSignatures.length, (index) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

//BELOW IS WORKING

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots; // absolute positions

//   late double _sigWidth;
//   late double _sigHeight;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSize();
//     _computeSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Dynamically compute signature size to avoid overlaps
//   void _computeImageSize() {
//     final size = MediaQuery.of(context).size;
//     final n = widget.signatures.length.clamp(1, 30); // max 30
//     final cols = (sqrt(n)).ceil();
//     final rows = (n / cols).ceil();
//     final padding = 10.0;

//     _sigWidth = (size.width - padding * (cols + 1)) / cols;
//     _sigHeight = (size.height - padding * (rows + 1)) / rows;
//   }

//   /// Generate non-overlapping positions using a grid with small random offsets
//   void _computeSpots() {
//     final size = MediaQuery.of(context).size;
//     final n = widget.signatures.length.clamp(1, 30);
//     final cols = (sqrt(n)).ceil();
//     final rows = (n / cols).ceil();
//     final padding = 10.0;

//     _spots = [];
//     final placedRects = <Rect>[];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= n) break;

//         double dx = padding + c * (_sigWidth + padding);
//         double dy = padding + r * (_sigHeight + padding);

//         // small random offset inside the cell
//         dx += _random.nextDouble() * (_sigWidth * 0.2);
//         dy += _random.nextDouble() * (_sigHeight * 0.2);

//         final rect = Rect.fromLTWH(dx, dy, _sigWidth, _sigHeight);

//         // safety check
//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length); // safe
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Container(
//                 color: Colors.black,
//                 child: Image.network(
//                   'https://sign.onecodephoto.com${sig.filename}',
//                   fit: BoxFit.fill,
//                   errorBuilder:
//                       (_, __, ___) => Container(color: Colors.grey[200]),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

//UP IS WORKING

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots; // absolute positions
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndMaxDisplay();
//     _computeSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and maximum number that can fit on screen
//   void _computeImageSizeAndMaxDisplay() {
//     final size = MediaQuery.of(context).size;
//     final padding = 10.0;
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     // Compute how many columns and rows can fit
//     final cols = ((size.width - padding) / (maxSigWidth + padding)).floor();
//     final rows = ((size.height - padding) / (maxSigHeight + padding)).floor();

//     _sigWidth = (size.width - padding * (cols + 1)) / cols;
//     _sigHeight = (size.height - padding * (rows + 1)) / rows;

//     _maxDisplay = cols * rows;
//   }

//   /// Generate non-overlapping positions using a grid with small random offsets
//   void _computeSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 10.0;

//     _spots = [];
//     final placedRects = <Rect>[];

//     final cols = ((size.width - padding) / (_sigWidth + padding)).floor();
//     final rows = ((size.height - padding) / (_sigHeight + padding)).floor();

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         double dx = padding + c * (_sigWidth + padding);
//         double dy = padding + r * (_sigHeight + padding);

//         // Small random offset inside the cell
//         dx += _random.nextDouble() * (_sigWidth * 0.2);
//         dy += _random.nextDouble() * (_sigHeight * 0.2);

//         final rect = Rect.fromLTWH(dx, dy, _sigWidth, _sigHeight);

//         // Safety check (should never overlap in this grid method)
//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length); // safe
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
/////1231231323
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots; // absolute positions
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and spots to fully fill the screen
//   void _computeImageSizeAndSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 5.0; // minimal padding to fit more images
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     // Start with max signature size
//     double sigWidth = maxSigWidth;
//     double sigHeight = maxSigHeight;

//     // Compute how many columns and rows can fit
//     int cols = ((size.width - padding) / (sigWidth + padding)).floor();
//     int rows = ((size.height - padding) / (sigHeight + padding)).floor();

//     // Shrink signature size slightly to fill leftover space
//     if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
//     if (rows > 0) sigHeight = (size.height - padding * (rows + 1)) / rows;

//     _sigWidth = sigWidth;
//     _sigHeight = sigHeight;
//     _maxDisplay = cols * rows;

//     // Generate non-overlapping positions
//     _spots = [];
//     final placedRects = <Rect>[];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         double dx = padding + c * (sigWidth + padding);
//         double dy = padding + r * (sigHeight + padding);

//         // Small random offset inside the cell
//         dx += _random.nextDouble() * (sigWidth * 0.15);
//         dy += _random.nextDouble() * (sigHeight * 0.15);

//         final rect = Rect.fromLTWH(dx, dy, sigWidth, sigHeight);

//         // Safety check
//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length); // safe
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

//1312312312

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots; // absolute positions
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and spots to fully fill the screen
//   void _computeImageSizeAndSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 5.0; // minimal padding to fit more images
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     // Start with max signature size
//     double sigWidth = maxSigWidth;
//     double sigHeight = maxSigHeight;

//     // Compute how many columns and rows can fit
//     int cols = ((size.width - padding) / (sigWidth + padding)).floor();
//     int rows = ((size.height - padding) / (sigHeight + padding)).floor();

//     // Shrink signature size slightly to fill leftover space
//     if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
//     if (rows > 0) sigHeight = (size.height - padding * (rows + 1)) / rows;

//     _sigWidth = sigWidth;
//     _sigHeight = sigHeight;
//     _maxDisplay = cols * rows;

//     // Generate non-overlapping positions
//     _spots = [];
//     final placedRects = <Rect>[];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         double dx = padding + c * (sigWidth + padding);
//         double dy = padding + r * (sigHeight + padding);

//         // Small random offset inside the cell
//         dx += _random.nextDouble() * (sigWidth * 0.15);
//         dy += _random.nextDouble() * (sigHeight * 0.15);

//         // Clamp to prevent cutting at bottom/right
//         dx = dx.clamp(0, size.width - sigWidth);
//         dy = dy.clamp(0, size.height - sigHeight);

//         final rect = Rect.fromLTWH(dx, dy, sigWidth, sigHeight);

//         // Skip if overlapping
//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length); // safe
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         // Signatures
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

//12312313123

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots;
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and safe positions
//   void _computeImageSizeAndSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 5.0;
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     double sigWidth = maxSigWidth;
//     double sigHeight = maxSigHeight;

//     int cols = ((size.width - padding) / (sigWidth + padding)).floor();
//     int rows = ((size.height - padding) / (sigHeight + padding)).floor();

//     if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
//     if (rows > 0) sigHeight = (size.height - padding * (rows + 1)) / rows;

//     _sigWidth = sigWidth;
//     _sigHeight = sigHeight;
//     _maxDisplay = cols * rows;

//     _spots = [];
//     final placedRects = <Rect>[];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         double dx = padding + c * (sigWidth + padding);
//         double dy = padding + r * (sigHeight + padding);

//         // Maximum safe offset to avoid cutting off
//         double maxOffsetX = max(0, size.width - sigWidth - dx - padding);
//         double maxOffsetY = max(0, size.height - sigHeight - dy - padding);

//         dx += _random.nextDouble() * min(sigWidth * 0.15, maxOffsetX);
//         dy += _random.nextDouble() * min(sigHeight * 0.15, maxOffsetY);

//         final rect = Rect.fromLTWH(dx, dy, sigWidth, sigHeight);

//         if (placedRects.any((r) => r.overlaps(rect))) continue;

//         placedRects.add(rect);
//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length);
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots;
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and safe positions
//   void _computeImageSizeAndSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 5.0;
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     double sigWidth = maxSigWidth;
//     double sigHeight = maxSigHeight;

//     int cols = ((size.width - padding) / (sigWidth + padding)).floor();
//     int rows = ((size.height - padding) / (sigHeight + padding)).floor();

//     if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
//     if (rows > 0) sigHeight = (size.height - padding * (rows + 1)) / rows;

//     _sigWidth = sigWidth;
//     _sigHeight = sigHeight;
//     _maxDisplay = cols * rows;

//     _spots = [];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         // Base cell position
//         double dx = padding + c * (sigWidth + padding);
//         double dy = padding + r * (sigHeight + padding);

//         // Maximum random offset safely inside the cell
//         double cellWidth = sigWidth + padding;
//         double cellHeight = sigHeight + padding;
//         double maxOffsetX = max(0, cellWidth - sigWidth);
//         double maxOffsetY = max(0, cellHeight - sigHeight);

//         dx += _random.nextDouble() * maxOffsetX;
//         dy += _random.nextDouble() * maxOffsetY;

//         // Clamp to screen bounds to be extra safe
//         dx = dx.clamp(0, size.width - sigWidth);
//         dy = dy.clamp(0, size.height - sigHeight);

//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length);
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../../domain/entities/signature_url.dart';

// class RandomSignatureScreen extends StatefulWidget {
//   final List<SignatureUrl> signatures;
//   final String background;

//   const RandomSignatureScreen({
//     super.key,
//     required this.signatures,
//     required this.background,
//   });

//   @override
//   State<RandomSignatureScreen> createState() => _RandomSignatureScreenState();
// }

// class _RandomSignatureScreenState extends State<RandomSignatureScreen> {
//   final Random _random = Random();
//   late List<SignatureUrl> _currentSignatures;
//   late List<bool> _visibleSignatures;
//   late List<Offset> _spots;
//   late double _sigWidth;
//   late double _sigHeight;
//   late int _maxDisplay;

//   @override
//   void initState() {
//     super.initState();
//     _currentSignatures = [];
//     _visibleSignatures = [];
//     _spots = [];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     _animateSignaturesSequentially();
//   }

//   /// Compute signature size and safe positions
//   void _computeImageSizeAndSpots() {
//     final size = MediaQuery.of(context).size;
//     final padding = 5.0;
//     final maxSigWidth = 120.0;
//     final maxSigHeight = 120.0;

//     double sigWidth = maxSigWidth;
//     double sigHeight = maxSigHeight;

//     int cols = ((size.width - padding) / (sigWidth + padding)).floor();
//     int rows = ((size.height - padding) / (sigHeight + padding)).floor();

//     if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
//     if (rows > 0) {
//       sigHeight = (size.height - padding * (rows + 1)) / rows;
//       sigHeight *= 0.98; // shrink 2% to prevent bottom cut
//     }

//     _sigWidth = sigWidth;
//     _sigHeight = sigHeight;
//     _maxDisplay = cols * rows;

//     _spots = [];

//     for (int r = 0; r < rows; r++) {
//       for (int c = 0; c < cols; c++) {
//         if (_spots.length >= _maxDisplay) break;

//         // Base cell position
//         double dx = padding + c * (sigWidth + padding);
//         double dy = padding + r * (sigHeight + padding);

//         // Maximum random offset safely inside the cell
//         double cellWidth = sigWidth + padding;
//         double cellHeight = sigHeight + padding;
//         double maxOffsetX = max(0, cellWidth - sigWidth);
//         double maxOffsetY = max(0, cellHeight - sigHeight);

//         dx += _random.nextDouble() * maxOffsetX;
//         dy += _random.nextDouble() * maxOffsetY;

//         // Clamp to screen bounds
//         dx = dx.clamp(0, size.width - sigWidth);
//         dy = dy.clamp(0, size.height - sigHeight);

//         _spots.add(Offset(dx, dy));
//       }
//     }
//   }

//   /// Assign images to the spots safely
//   void _prepareNextSet() {
//     final n = min(widget.signatures.length, _spots.length);
//     _currentSignatures = List.from(widget.signatures)..shuffle(_random);
//     _currentSignatures = _currentSignatures.take(n).toList();
//     _visibleSignatures = List.filled(n, false);
//   }

//   /// Animate images fading in and out
//   Future<void> _animateSignaturesSequentially() async {
//     final indices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);

//     for (final i in indices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 500));
//       setState(() => _visibleSignatures[i] = true);
//     }

//     await Future.delayed(const Duration(seconds: 10));
//     if (!mounted) return;

//     final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
//       ..shuffle(_random);
//     for (final i in fadeOutIndices) {
//       if (!mounted) return;
//       await Future.delayed(const Duration(milliseconds: 100));
//       setState(() => _visibleSignatures[i] = false);
//     }

//     await Future.delayed(const Duration(milliseconds: 300));
//     if (!mounted) return;

//     _computeImageSizeAndSpots();
//     _prepareNextSet();
//     await _animateSignaturesSequentially();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child:
//               widget.background.isNotEmpty
//                   ? Image.network(
//                     'https://sign.onecodephoto.com/${widget.background}',
//                     fit: BoxFit.cover,
//                   )
//                   : const SizedBox.shrink(),
//         ),
//         ...List.generate(min(_visibleSignatures.length, _spots.length), (
//           index,
//         ) {
//           final pos = _spots[index];
//           final sig = _currentSignatures[index];

//           return AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             left: pos.dx,
//             top: pos.dy,
//             width: _sigWidth,
//             height: _sigHeight,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _visibleSignatures[index] ? 1.0 : 0.0,
//               child: Image.network(
//                 'https://sign.onecodephoto.com${sig.filename}',
//                 fit: BoxFit.fill,
//                 errorBuilder:
//                     (_, __, ___) => Container(color: Colors.grey[200]),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
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
  late List<SignatureUrl> _currentSignatures;
  late List<bool> _visibleSignatures;
  late List<Offset> _spots;
  late double _sigWidth;
  late double _sigHeight;

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
    _computeImageSizeAndSpots();
    _prepareNextSet();
    _animateSignaturesSequentially();
  }

  /// Compute signature size and safe positions (no cut)
  void _computeImageSizeAndSpots() {
    final size = MediaQuery.of(context).size;
    final padding = 5.0;
    final maxSigWidth = 120.0;
    final maxSigHeight = 120.0;

    double sigWidth = maxSigWidth;
    double sigHeight = maxSigHeight;

    int cols = ((size.width - padding) / (sigWidth + padding)).floor();
    int rows = ((size.height - padding) / (sigHeight + padding)).floor();

    if (cols > 0) sigWidth = (size.width - padding * (cols + 1)) / cols;
    if (rows > 0) sigHeight = (size.height - padding * (rows + 1)) / rows;

    _sigWidth = sigWidth;
    _sigHeight = sigHeight;

    _spots = [];
    final placedRects = <Rect>[];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        double dx = padding + c * (sigWidth + padding);
        double dy = padding + r * (sigHeight + padding);

        // Maximum safe offset for inner rows/columns
        double maxOffsetX = max(0, size.width - sigWidth - dx - padding);
        double maxOffsetY = max(0, size.height - sigHeight - dy - padding);

        if (c < cols - 1 && maxOffsetX > 0)
          dx += _random.nextDouble() * min(sigWidth * 0.15, maxOffsetX);
        if (r < rows - 1 && maxOffsetY > 0)
          dy += _random.nextDouble() * min(sigHeight * 0.15, maxOffsetY);

        // Skip if this spot would be partially off-screen
        if (dx + sigWidth > size.width - padding ||
            dy + sigHeight > size.height - padding) {
          continue;
        }

        final rect = Rect.fromLTWH(dx, dy, sigWidth, sigHeight);

        if (placedRects.any((r) => r.overlaps(rect))) continue;

        placedRects.add(rect);
        _spots.add(Offset(dx, dy));
      }
    }
  }

  /// Assign images to the spots safely
  void _prepareNextSet() {
    final n = min(widget.signatures.length, _spots.length);
    _currentSignatures = List.from(widget.signatures)..shuffle(_random);
    _currentSignatures = _currentSignatures.take(n).toList();
    _visibleSignatures = List.filled(n, false);
  }

  /// Animate images fading in and out
  Future<void> _animateSignaturesSequentially() async {
    final indices = List.generate(_visibleSignatures.length, (i) => i)
      ..shuffle(_random);

    for (final i in indices) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _visibleSignatures[i] = true);
    }

    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;

    final fadeOutIndices = List.generate(_visibleSignatures.length, (i) => i)
      ..shuffle(_random);
    for (final i in fadeOutIndices) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => _visibleSignatures[i] = false);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    _computeImageSizeAndSpots();
    _prepareNextSet();
    await _animateSignaturesSequentially();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child:
              widget.background.isNotEmpty
                  ? Image.network(
                    'https://sign.onecodephoto.com/${widget.background}',
                    fit: BoxFit.cover,
                  )
                  : const SizedBox.shrink(),
        ),
        // Signatures
        ...List.generate(min(_visibleSignatures.length, _spots.length), (
          index,
        ) {
          final pos = _spots[index];
          final sig = _currentSignatures[index];

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: pos.dx,
            top: pos.dy,
            width: _sigWidth,
            height: _sigHeight,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _visibleSignatures[index] ? 1.0 : 0.0,
              child: Container(
                color: Colors.black,
                child: Image.network(
                  'https://sign.onecodephoto.com${sig.filename}',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
