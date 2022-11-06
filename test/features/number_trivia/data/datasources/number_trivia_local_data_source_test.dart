
import 'dart:convert';

import 'package:clean_tdd_trivia_app/src/core/cache/cache.dart';
import 'package:clean_tdd_trivia_app/src/core/error/exceptions.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<SharedPreferences>()
])

void main() {
  late MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  late NumberTriviaLocalDataSourceImpl dataSource;
  late Cache cache;

  setUp(() {
    cache = Cache(sharedPreferences: mockSharedPreferences);
    dataSource = NumberTriviaLocalDataSourceImpl(cache: cache);
  });

  final tNumberTrivia = NumberTriviaModel.fromMap(jsonDecode(fixture('trivia.json')));

  group(
    "getRandomNumberTrivia:",
    () {
      when(mockSharedPreferences.getStringList(any)).thenAnswer((realInvocation) => [tNumberTrivia.toJson()]);
      test(
        "should return Random NumberTriviaModel from the cache",
        () async  {

            final response = dataSource.getRandomNumberTrivia();
            
            verify(mockSharedPreferences.getStringList(Cache.listTrivias));
            expect(response, tNumberTrivia);
        },
      );
      test(
        "should return CacheExeption from the cache",
        () async  {
            when(mockSharedPreferences.getStringList(any)).thenReturn([]);

            final call = dataSource.getRandomNumberTrivia;
            
            expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
        },
      );

    },
  );

  group(
    "getConcreteNumberTrivia:",
    () {
      final tNumberTrivia = NumberTriviaModel.fromMap(jsonDecode(fixture('trivia.json')));
      test(
        "should return NumberTriviaModel of number pass from the cache",
        () async  {
            when(mockSharedPreferences.getStringList(any)).thenAnswer((realInvocation) => [tNumberTrivia.toJson()]);

            final response = dataSource.getConcreteNumberTrivia(tNumberTrivia.number);
            
            verify(mockSharedPreferences.getStringList(Cache.listTrivias));
            expect(response, tNumberTrivia);
        },
      );
      test(
        "should return CacheExeption from the cache",
        () async  {
            when(mockSharedPreferences.getStringList(any)).thenReturn([]);

            final call = dataSource.getConcreteNumberTrivia;
            
            expect(() => call(1), throwsA(const TypeMatcher<CacheException>()));
        },
      );

    },
  );

  group('cacheTrivia:', () {
    test('should call SharedPreferences to cache the data', () async {
      await dataSource.cacheNumberTrivia(tNumberTrivia);

      verify(mockSharedPreferences.setStringList(Cache.listTrivias, [tNumberTrivia.toJson()]));
    });
  });

}