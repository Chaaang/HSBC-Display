import 'package:hsbc_display/features/signatures/domain/entities/signature_url.dart';

abstract class SignatureState {}

class SignatureInitialState extends SignatureState {}

class SignatureLoadedState extends SignatureState {
  List<SignatureUrl> signature;
  String background;
  String fadeInSeconds;
  String freezeInSeconds;

  SignatureLoadedState(
    this.signature,
    this.background,
    this.fadeInSeconds,
    this.freezeInSeconds,
  );
}

class SignatureLoadingState extends SignatureState {}

class SignatureErrorState extends SignatureState {
  String error;

  SignatureErrorState(this.error);
}

class SignatureEmptyState extends SignatureState {}
