
import 'package:clean_tdd_trivia_app/src/core/usecases/usecase.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_random_number_trivia_test.mocks.dart';
@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const NumberTrivia testNumberTrivia = NumberTrivia(text: '1 o foda', number: 1, found: true);

  test(
    'should get random trivia from the repository',
    () async {
      when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer(        
        (_) async => const Right(testNumberTrivia)
      );

      final response = await usecase(NoParams());

      expect(response, const Right(testNumberTrivia));

      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

}