
import 'dart:convert';

import 'package:clean_tdd_trivia_app/src/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  
  const NumberTriviaModel({required super.text, required super.number, required super.found});

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
}