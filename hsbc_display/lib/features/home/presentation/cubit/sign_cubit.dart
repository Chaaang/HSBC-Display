import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsbc_display/features/home/domain/repo/sign_repo.dart';
import 'package:hsbc_display/features/home/presentation/cubit/sign_state.dart';

import '../../../event/domain/entities/event.dart';

class SignCubit extends Cubit<SignState> {
  final SignRepo signRepo;

  String? _currentSignId;
  Event? _currentEvent;
  SignCubit({required this.signRepo}) : super(SignInitial());

  Future<void> getCurrentEvent(Event event) async {
    _currentEvent = event;
    _currentSignId = _currentEvent!.id;
    emit(SignLoading());
    try {
      if (_currentEvent != null) {
        emit(SignLoaded(_currentEvent));
      }
    } catch (e) {
      emit(SignError(e.toString()));
    }
  }

  Future<void> saveSignatureBase64(
    Uint8List file,
    String userId,
    String signId,
  ) async {
    try {
      emit(SignLoading());

      await signRepo.uploadSign(file, userId, signId);

      await getCurrentEvent(_currentEvent!);
    } catch (e) {
      emit(SignError(e.toString()));
    }
  }

  String? get currentSignId => _currentSignId;

  // Future<void> getSignItem(String uuid) async {
  //   _currentUserId = uuid;
  //   try {
  //     emit(SignLoading());
  //     final item = await signRepo.getSignItem(uuid);

  //     if (item != null) {
  //       _currentSignId = item.id;
  //       //emit(SignLoaded(item));
  //     }
  //   } catch (e) {
  //     emit(SignError(e.toString()));
  //   }
  // }

  // Future<void> saveSignatureBase64(
  //   Uint8List file,
  //   String userId,
  //   String signId,
  // ) async {
  //   try {
  //     emit(SignLoading());

  //     await signRepo.uploadSign(file, userId, signId);

  //     await getSignItem(_currentUserId!);
  //   } catch (e) {
  //     emit(SignError(e.toString()));
  //   }
  // }
}
