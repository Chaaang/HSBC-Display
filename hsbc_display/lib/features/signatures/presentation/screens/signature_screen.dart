import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsbc_display/features/shared/components/loading_screen.dart';
import 'package:hsbc_display/features/signatures/domain/entities/signature_url.dart';
import 'package:hsbc_display/features/signatures/presentation/components/signature_grid.dart';
import 'package:hsbc_display/features/signatures/presentation/cubit/signature_cubit.dart';
import 'package:hsbc_display/features/signatures/presentation/cubit/signature_state.dart';

import '../../../event/presentation/cubit/event_cubit.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Timer? _timer;
  int time = 5;
  @override
  void initState() {
    super.initState();
    loadSignatures();
    _timer = Timer.periodic(Duration(seconds: time), (_) {
      _refreshSignatures();
    });
    print('THIS IS TIME $time');
  }

  void loadSignatures() {
    final eventCubit = context.read<EventCubit>();
    final signId = eventCubit.currentEvent!.id;
    final bg = eventCubit.currentEvent!.signsShowBg;
    time = int.parse(eventCubit.currentEvent!.listRefreshSecods);

    var fadeInSec = eventCubit.currentEvent!.fadeInSeconds;
    var freezeInSec = eventCubit.currentEvent!.freezeInSeconds;
    context.read<SignatureCubit>().getSignatures(
      signId,
      bg,
      fadeInSec,
      freezeInSec,
    );
  }

  void _refreshSignatures() {
    final eventCubit = context.read<EventCubit>();
    final signId = eventCubit.currentEvent!.id;
    final bg = eventCubit.currentEvent!.signsShowBg;
    var fadeInSec = eventCubit.currentEvent!.fadeInSeconds;
    var freezeInSec = eventCubit.currentEvent!.freezeInSeconds;
    context.read<SignatureCubit>().refreshSignatures(
      signId,
      bg,
      fadeInSec,
      freezeInSec,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SignatureCubit, SignatureState>(
        builder: (context, state) {
          if (state is SignatureLoadingState) {
            return LoadingScreen();
          } else if (state is SignatureErrorState) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is SignatureEmptyState) {
            return const Center(child: Text('No signatures found.'));
          } else if (state is SignatureLoadedState) {
            final List<SignatureUrl> signatures = state.signature;
            final String bg = state.background;
            int fadeInSec = int.parse(state.fadeInSeconds);
            int freezeSec = int.parse(state.freezeInSeconds);

            return RandomSignatureScreen(
              signatures: signatures,
              background: bg,
              fadeInSec: fadeInSec,
              freezeInSec: freezeSec,
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
