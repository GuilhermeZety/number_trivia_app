import 'dart:convert';

import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {  
  const testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'testando', found: true);

  test(
    'should ba a subclass of NumberTrivia entity',
    () async {
      expect(testNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'Conversions:',
    () {
      group(
        'from JSON:',
        () {
          test(
            'should return a valid model when the JSON number is an integer',
            () async {
              final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

              final response = NumberTriviaModel.fromMap(jsonMap);

              expect(response, isA<NumberTriviaModel>());
            },
          );
          test(
            'should return a valid model when the JSON number is an double',
            () async {
              final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double.json'));

              final response = NumberTriviaModel.fromMap(jsonMap);

              expect(response, isA<NumberTriviaModel>());
            },
          );
        },
      );
      test(
        'should return a Map containing the proper data',
        () async {
          final response = testNumberTriviaModel.toMap();
          
          final expectedMap = {
              "text": "testando",
              "number": 1,
              "found": true
          };

          expect(response, expectedMap);
        },
      );

      test(
        'should return a JSON containing the proper data',
        () async {
          final response = testNumberTriviaModel.toJson();
          
          const expectedJson = '{"text":"testando","number":1,"found":true}';

          expect(response, expectedJson);
        },
      );
    }
  );
  
}