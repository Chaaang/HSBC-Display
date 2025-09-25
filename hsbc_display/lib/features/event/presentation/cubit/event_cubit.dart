import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/event.dart';
import '../../domain/repo/event_repo.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventRepo eventRepo;

  Event? _currentEvent;
  EventCubit({required this.eventRepo}) : super(EventIntial());

  Future<void> getEventList(String uuid) async {
    try {
      emit(EventLoading());

      final events = await eventRepo.getEventItems(uuid);

      if (events.isNotEmpty) {
        emit(EventLoaded(events));
      } else {
        emit(EventEmpty());
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Event? get currentEvent => _currentEvent;

  // Call this when user selects an event from dropdown
  void selectEvent(Event event) {
    _currentEvent = event;
    // Optionally emit a new state if you want the UI to react
  }

  void navigate() {
    emit(EventReady());
  }
}
