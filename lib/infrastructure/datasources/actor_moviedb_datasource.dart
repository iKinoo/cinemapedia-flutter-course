import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_reponse.dart';



class ActorMoviedbDatasource extends ActorsDatasource{

  final dio = Dio(
      BaseOptions(baseUrl: 'https://api.themoviedb.org/3', queryParameters: {
    'api_key': Environment.theMovieDbKey,
    'language': 'es-MX',
  }));

  List<Actor> _jsonToMovies(Map<String, dynamic> json) {
    final creditsResponse = CreditsResponse.fromJson(json);

    final List<Actor> movies = creditsResponse.cast
        .where((actorMoviedb) => actorMoviedb.profilePath != 'no-poster')
        .map((actorMoviedb) => ActorMapper.castToEntity(actorMoviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{
    
    final response = await dio.get('/movie/$movieId/credits');

    if (response.statusCode == 200) {
      return _jsonToMovies(response.data);
    } else {
      throw Exception('Failed to load actors');
    }
    
  }
  

}