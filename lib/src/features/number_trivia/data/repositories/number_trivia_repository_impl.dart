// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_tdd_trivia_app/src/core/error/exceptions.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/enums/concrete_or_random_enum.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async  {
     return await _getTrivia(ConcreteOrRandom.concrete, number: number);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
     return await _getTrivia(ConcreteOrRandom.random);
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(ConcreteOrRandom concreteOrRandom, {int? number}) async {
    if(await networkInfo.isConnected){
      try{
        final NumberTriviaModel remoteTrivia;

        if(concreteOrRandom == ConcreteOrRandom.concrete){
          remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number!);
        }
        else{
          remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
        }

        await localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    else{
      try{
        
        final NumberTriviaModel localTrivia;
        
        if(concreteOrRandom == ConcreteOrRandom.concrete){
          localTrivia = localDataSource.getConcreteNumberTrivia(number!);
        }
        else{
          localTrivia = localDataSource.getRandomNumberTrivia();
        }

        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
