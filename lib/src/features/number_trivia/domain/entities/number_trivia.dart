import 'dart:convert';

import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  @override
  List<Object> get props => [text, number, found];
  
  final String text;
  final int number;
  final bool found;


  const NumberTrivia({
    required this.text,
    required this.number,
    required this.found,
  });

  NumberTrivia copyWith({
    String? text,
    int? number,
    bool? found,
  }) {
    return NumberTrivia(
      text: text ?? this.text,
      number: number ?? this.number,
      found: found ?? this.found,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'number': number,
      'found': found,
    };
  }

  factory NumberTrivia.fromMap(Map<String, dynamic> map) {
    return NumberTrivia(
      text: map['text'] as String,
      number: map['number'] as int,
      found: map['found'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumberTrivia.fromJson(String source) => NumberTrivia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
