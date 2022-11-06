
import 'package:clean_tdd_trivia_app/src/core/error/exceptions.dart';
import 'package:clean_tdd_trivia_app/src/core/error/failures.dart';
import 'package:clean_tdd_trivia_app/src/core/network/network_info.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';
@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(), 
  MockSpec<NumberTriviaLocalDataSource>(), 
  MockSpec<NetworkInfo>()
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });


  void runTestsOnline(Function body){
    group(
      "device is online:",
      () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        body();
      }
    );
  }

  void runTestsOffline(Function body){
    group(
      "device is offline:",
      () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        body();
      }
    );
  }
  group(
    "getConcreteNumberTrivia:",
    () {
      const testNumber = 1;
      const testNumberTriviaModel = NumberTriviaModel(text: 'foda', number: testNumber, found: true);      
      const NumberTrivia testNumberTriviaEntity = testNumberTriviaModel;      

      test(
        "should check if device is online",
        () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          await repository.getConcreteNumberTrivia(testNumber);

          verify(mockNetworkInfo.isConnected);
        },
      );
    
      runTestsOnline(() {
          test(
            "should return remote data when the call to remote data source is successful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => testNumberTriviaModel);

              var response = await repository.getConcreteNumberTrivia(testNumber);

              verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));

              expect(response, const Right(testNumberTriviaEntity));
            },
          );

           test(
            "should cache to data locally when the call to remote data source is successful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => testNumberTriviaModel);

              var response = await repository.getConcreteNumberTrivia(testNumber);

              verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));
              verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));

              expect(response, const Right(testNumberTriviaEntity));
            },
          );

          test(
            "should return server failure ta when the call to remote data source is unsuccessful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());

              var response = await repository.getConcreteNumberTrivia(testNumber);

              verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));

              verifyZeroInteractions(mockNumberTriviaLocalDataSource);

              expect(response, Left(ServerFailure()));
            },
          );
        },
      );
      
      runTestsOffline(() {
          test(
            "should return local data when the cached data is present",
            () async {
              when(mockNumberTriviaLocalDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) => testNumberTriviaModel);

              var response = await repository.getConcreteNumberTrivia(testNumber);

              verify(mockNumberTriviaLocalDataSource.getConcreteNumberTrivia(testNumber));

              expect(response, const Right(testNumberTriviaEntity));
            },
          );          
          
          test(
            "should return cache failure there is no cached data present",
            () async {
              when(mockNumberTriviaLocalDataSource.getConcreteNumberTrivia(any)).thenThrow(CacheException());

              var response = await repository.getConcreteNumberTrivia(testNumber);

              verify(mockNumberTriviaLocalDataSource.getConcreteNumberTrivia(testNumber));

              expect(response, Left(CacheFailure()));
            },
          );
        },
      );
    },
  );

  group(
    "getRandomNumberTrivia:",
    () {

      const testNumberTriviaModel = NumberTriviaModel(text: 'foda', number: 1, found: true);      
      const NumberTrivia testNumberTriviaEntity = testNumberTriviaModel;      

      test(
        "should check if device is online",
        () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          await repository.getRandomNumberTrivia();

          verify(mockNetworkInfo.isConnected);
        },
      );
    
      runTestsOnline(() {
          test(
            "should return remote data when the call to remote data source is successful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);

              var response = await repository.getRandomNumberTrivia();

              verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());

              expect(response, const Right(testNumberTriviaEntity));
            },
          );

           test(
            "should cache to data locally when the call to remote data source is successful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);

              var response = await repository.getRandomNumberTrivia();

              verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
              verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));

              expect(response, const Right(testNumberTriviaEntity));
            },
          );

          test(
            "should return server failure ta when the call to remote data source is unsuccessful",
            () async {
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

              var response = await repository.getRandomNumberTrivia();

              verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());

              verifyZeroInteractions(mockNumberTriviaLocalDataSource);

              expect(response, Left(ServerFailure()));
            },
          );
        },
      );
      
      runTestsOffline(() {
          test(
            "should return local data when the cached data is present",
            () async {
              when(mockNumberTriviaLocalDataSource.getRandomNumberTrivia()).thenAnswer((_) => testNumberTriviaModel);

              var response = await repository.getRandomNumberTrivia();

              verify(mockNumberTriviaLocalDataSource.getRandomNumberTrivia());

              expect(response, const Right(testNumberTriviaEntity));
            },
          );          
          
          test(
            "should return cache failure there is no cached data present",
            () async {
              when(mockNumberTriviaLocalDataSource.getRandomNumberTrivia()).thenThrow(CacheException());

              var response = await repository.getRandomNumberTrivia();

              verify(mockNumberTriviaLocalDataSource.getRandomNumberTrivia());

              expect(response, Left(CacheFailure()));
            },
          );
        },
      );
    },
  );  
}