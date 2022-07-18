import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app_clean_tdd/core/error/exception.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

class MSharedPreferences extends Mock implements SharedPreferences {}

@GenerateMocks([MSharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockMSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockMSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(
          mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ),
        );
      },
    );
  });
}
