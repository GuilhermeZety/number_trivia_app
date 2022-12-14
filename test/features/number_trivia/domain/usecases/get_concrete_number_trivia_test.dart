
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';
@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const int testNumber = 10;
  const NumberTrivia testNumberTrivia = NumberTrivia(text: '1 o foda', number: testNumber, found: true);

  test(
    'should get trivia for the number from the repository',
    () async {
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(        
        (_) async => const Right(testNumberTrivia)
      );

      final response = await usecase(const Params(number: testNumber));

      expect(response, const Right(testNumberTrivia));

      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

}