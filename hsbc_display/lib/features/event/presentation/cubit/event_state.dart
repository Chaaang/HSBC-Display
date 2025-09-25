import '../../domain/entities/event.dart';

abstract class EventState {}

class EventIntial extends EventState {}

class EventLoaded extends EventState {
  List<Event> events;

  EventLoaded(this.events);
}

class EventError extends EventState {
  String error;

  EventError(this.error);
}

class EventLoading extends EventState {}

class EventEmpty extends EventState {}

class EventReady extends EventState {}
