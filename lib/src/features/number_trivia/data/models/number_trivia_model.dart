import 'dart:convert';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel(
      {required super.text, required super.number, required super.found});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
      'found': found,
    };
  }

  @override
  String toJson() => jsonEncode(toMap());

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'],
      number: (map['number'] as num).toInt(),
      found: map['found'],
    );
  }

  factory NumberTriviaModel.fromJson(String source) =>
      NumberTriviaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
