import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app_clean_tdd/core/use_cases/usecase.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_number_trivia_test.mocks.dart';

class MNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

@GenerateMocks([MNumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia concreteNumberUseCase;
  late GetRandomNumberTrivia randomNumberUseCase;
  late MockMNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockMNumberTriviaRepository();
    concreteNumberUseCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    randomNumberUseCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await concreteNumberUseCase(const Params(number: tNumber));
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

  test(
    'should get random trivia from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await randomNumberUseCase(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
