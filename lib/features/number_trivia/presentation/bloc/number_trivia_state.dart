part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaSuccess extends NumberTriviaState {
  const NumberTriviaSuccess(this.trivia);

  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  const Error(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
