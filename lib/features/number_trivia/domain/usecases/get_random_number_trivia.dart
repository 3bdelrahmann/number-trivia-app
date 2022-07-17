import 'package:dartz/dartz.dart';
import 'package:number_trivia_app_clean_tdd/core/error/failures.dart';
import 'package:number_trivia_app_clean_tdd/core/use_cases/usecase.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
