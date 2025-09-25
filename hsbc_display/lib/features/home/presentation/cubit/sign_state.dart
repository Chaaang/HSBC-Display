import '../../../event/domain/entities/event.dart';

abstract class SignState {}

class SignInitial extends SignState {}

class SignLoading extends SignState {}

class SignLoaded extends SignState {
  Event? item;

  SignLoaded(this.item);
}

class SignError extends SignState {
  String error;

  SignError(this.error);
}

class SignSave extends SignState {}

class SignSaveSuccess extends SignState {}
