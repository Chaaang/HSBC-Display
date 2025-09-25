import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsbc_display/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:hsbc_display/features/event/presentation/cubit/event_cubit.dart';
import 'package:hsbc_display/features/home/presentation/components/my_floating_action_button.dart';
import 'package:hsbc_display/features/home/presentation/cubit/sign_cubit.dart';
import 'package:hsbc_display/features/home/presentation/cubit/sign_state.dart';
import 'package:hsbc_display/features/shared/components/loading_screen.dart';

import '../../../shared/components/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PainterController _controller;
  Color _selectedColor = Colors.black;
  final GlobalKey painterKey = GlobalKey();

  bool _showBox = true;
  final List<Color> _colors = [
    Colors.black,
    Color(0xFF724236),
    Color(0xFF548F46),
    Color(0xFF4442FB),
    Color(0xFFEA7600),
    Color(0xFFFF2A08),
    Color(0xFF8850C7),
  ];
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    getSignModel();
    _controller =
        PainterController()
          ..freeStyleMode = FreeStyleMode.draw
          ..freeStyleColor = Colors.black
          ..freeStyleStrokeWidth = 5.0;
  }

  @override
  void dispose() {
    _controller;
    super.dispose();
  }

  void getSignModel() {
    final eventCubit = context.read<EventCubit>();
    final signCubit = context.read<SignCubit>();
    var currentEvent = eventCubit.currentEvent;

    signCubit.getCurrentEvent(currentEvent!);
    // final signCubit = context.read<SignCubit>();
    // final authCubit = context.read<AuthCubit>();
    // final uuid = authCubit.currentUser;
    // if (uuid != null) {
    //   signCubit.getSignItem(uuid);
    // }
  }

  Future<void> _saveSignature() async {
    final signCubit = context.read<SignCubit>();
    final authCubit = context.read<AuthCubit>();
    final userId = authCubit.currentUser;
    final signId = signCubit.currentSignId;
    if (userId == null) return;

    // ✅ Prevent saving if nothing is drawn
    if (_controller.drawables.isEmpty) {
      showAppSnackBar(
        context,
        'Please sign before saving!',
        type: SnackBarType.error,
      );
      return;
    }

    try {
      const targetSize = Size(1200, 600);
      final uiImage = await _controller.renderImage(targetSize);

      // Convert ui.Image to Uint8List (PNG)
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      await signCubit.saveSignatureBase64(bytes, userId, signId!);

      if (!mounted) return;
      showAppSnackBar(
        context,
        'Upload signature complete!',
        type: SnackBarType.success,
      );
      _clearCanvas();
    } catch (e) {
      showAppSnackBar(context, 'Error Uploading: $e', type: SnackBarType.error);
    }
  }

  void _clearCanvas() {
    _controller.clearDrawables();
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setModalState) => Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_colors.length, (index) {
                    final color = _colors[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                          _controller.freeStyleSettings = _controller
                              .freeStyleSettings
                              .copyWith(color: color);
                        });
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(
                                color: Colors.black,
                                width: _selectedColor == color ? 3 : 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    );
                  }),
                ),
              ),
        );
      },
    );
  }

  void _logout() {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showBox = !_showBox; // trigger the signature box
        });
      },
      child: Scaffold(
        body: BlocConsumer<SignCubit, SignState>(
          builder: (context, state) {
            if (state is SignLoading) {
              return LoadingScreen();
            }
            if (state is SignLoaded) {
              final item = state.item!;
              return Stack(
                children: [
                  // Background with image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://sign.onecodephoto.com/${item.signsBackground}',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Show signature box in center when tapped
                  if (_showBox)
                    Center(
                      child: Container(
                        width: 600, // logical pixels
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: FlutterPainter(
                          key: painterKey,
                          controller: _controller,
                        ),
                      ),
                    ),
                ],
              );
            }

            return const Center(child: Text('ERROR'));
          },
          listener: (context, state) {},
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 72,
              width: 72,
              child: MyFloatingActionButton(
                herotag: 'upload',
                toolTip: 'Upload',
                onTap: _saveSignature,
                widget: const Icon(Icons.upload, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              width: 72,
              child: MyFloatingActionButton(
                herotag: 'color',
                toolTip: 'Change Pen Color',
                onTap: _showColorPicker,
                widget: const Icon(Icons.palette, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              width: 72,
              child: MyFloatingActionButton(
                herotag: 'clear',
                toolTip: 'Clear',
                onTap: _clearCanvas,
                widget: const Icon(Icons.clear, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              width: 72,
              child: MyFloatingActionButton(
                herotag: 'logout',
                toolTip: 'Logout',
                onTap: _logout,
                widget: const Icon(Icons.logout, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
