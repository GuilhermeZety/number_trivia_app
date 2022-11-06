// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_tdd_trivia_app/src/core/cache/cache.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  ///Gets the cached [NumberTriviaModel] from the number
  ///
  ///Throws a [CacheException] for all error codes.
  NumberTriviaModel getConcreteNumberTrivia(int number);

  ///Gets the random cached [NumberTriviaModel] 
  ///
  ///Throws a [CacheException] for all error codes.
  NumberTriviaModel getRandomNumberTrivia();

  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  Cache cache;
  
  NumberTriviaLocalDataSourceImpl({
    required this.cache,
  });

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    try{
      return cache.cacheNumberTrivia(triviaToCache);   
    }on CacheException {
      throw CacheException();
    }
  }

  @override
  NumberTriviaModel getConcreteNumberTrivia(int number) {
    try{
      return cache.getConcreteNumberTrivia(number);   
    }on CacheException {
      throw CacheException();
    }
  }

  @override
  NumberTriviaModel getRandomNumberTrivia() {
    try{
      return cache.getRandomNumberTrivia();   
    }on CacheException {
      throw CacheException();
    }
  }
  
}
