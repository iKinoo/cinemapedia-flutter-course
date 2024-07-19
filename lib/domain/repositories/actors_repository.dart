import '../entities/actor.dart';

abstract class ActorsRepository {
  Future<Actor> getActorsByMovie(String movieId);
}
