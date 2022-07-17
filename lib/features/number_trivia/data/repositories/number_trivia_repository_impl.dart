import 'package:dartz/dartz.dart';
import 'package:number_trivia_app_clean_tdd/core/error/exception.dart';
import 'package:number_trivia_app_clean_tdd/core/error/failures.dart';
import 'package:number_trivia_app_clean_tdd/core/network/network_info.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
