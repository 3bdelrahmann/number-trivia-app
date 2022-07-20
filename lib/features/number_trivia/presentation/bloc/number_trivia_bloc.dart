import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app_clean_tdd/core/error/failures.dart';
import 'package:number_trivia_app_clean_tdd/core/use_cases/usecase.dart';
import 'package:number_trivia_app_clean_tdd/core/util/input_converter.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>(
      (event, emit) async {
        if (event is GetTriviaForConcreteNumber) {
          final inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);
          await inputEither.fold(
              (failure) async => emit(const NumberTriviaFailed(
                  message: invalidInputFailureMessage)), (integer) async {
            emit(NumberTriviaLoading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrFailureState(emit, failureOrTrivia!);
          });
        } else if (event is GetTriviaForRandomNumber) {
          emit(NumberTriviaLoading());
          final failureOrTrivia = await getRandomNumberTrivia(NoParams());
          _eitherLoadedOrFailureState(emit, failureOrTrivia!);
        }
      },
    );
  }

  void _eitherLoadedOrFailureState(Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTrivia> failureOrTrivia) {
    emit(failureOrTrivia.fold(
        (failure) => NumberTriviaFailed(message: _mapFailureToMessage(failure)),
        (trivia) => NumberTriviaSuccess(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
