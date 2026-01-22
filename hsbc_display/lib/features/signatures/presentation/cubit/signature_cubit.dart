import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsbc_display/features/signatures/domain/repo/signature_repo.dart';
import 'package:hsbc_display/features/signatures/presentation/cubit/signature_state.dart';

class SignatureCubit extends Cubit<SignatureState> {
  final SignatureRepo signatureRepo;
  SignatureCubit({required this.signatureRepo})
    : super(SignatureInitialState());

  Future<void> getSignatures(
    String signId,
    String background,
    String fadeInSec,
    String freezeInSec,
  ) async {
    try {
      emit(SignatureLoadingState());

      final items = await signatureRepo.getSignatures(signId);

      if (items.isNotEmpty) {
        emit(SignatureLoadedState(items, background, fadeInSec, freezeInSec));
      } else {
        emit(SignatureEmptyState());
      }
    } catch (e) {
      emit(SignatureErrorState(e.toString()));
    }
  }

  Future<void> refreshSignatures(
    String signId,
    String background,
    String fadeInSec,
    freezeInSec,
  ) async {
    try {
      final items = await signatureRepo.getSignatures(signId);

      if (items.isNotEmpty) {
        emit(SignatureLoadedState(items, background, fadeInSec, freezeInSec));
      } else {
        emit(SignatureEmptyState());
      }
    } catch (e) {
      // Don’t block UI, but you can log or keep old state
      emit(SignatureErrorState(e.toString()));
    }
  }
}
