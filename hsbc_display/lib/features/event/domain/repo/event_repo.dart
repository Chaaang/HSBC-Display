import '../entities/event.dart';

abstract class EventRepo {
  Future<List<Event>> getEventItems(String uuid);
}
