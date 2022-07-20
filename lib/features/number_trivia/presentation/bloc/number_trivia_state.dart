part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaSuccess extends NumberTriviaState {
  const NumberTriviaSuccess({required this.trivia});

  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

class NumberTriviaFailed extends NumberTriviaState {
  const NumberTriviaFailed({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
