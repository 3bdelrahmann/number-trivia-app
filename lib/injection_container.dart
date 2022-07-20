import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

/// [GetIt.instance] is a callable class
final serviceLocator = GetIt.instance;

Future<void> init() async {
  /// Features - Number Trivia
  // Bloc
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  /// Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
