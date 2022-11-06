// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:clean_tdd_trivia_app/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

class Cache {
  static const String listTrivias = 'listTrivias';

  Cache({
    required this.sharedPreferences,
  });

  SharedPreferences sharedPreferences;

  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    List<String>? listT = sharedPreferences.getStringList(listTrivias);
    List<String> mainList = [];

    if (listT != null && listT.isNotEmpty) {
      listT.removeWhere((element) => NumberTriviaModel.fromJson(element) == triviaToCache);
      
      mainList = listT;
    }
    mainList.add(triviaToCache.toJson());

    return sharedPreferences.setStringList(listTrivias, mainList);
  }

  NumberTriviaModel getConcreteNumberTrivia(int number) {
    var response = sharedPreferences.getStringList(listTrivias);

    if (response != null && response.isNotEmpty) {
      for (var t in response) {
        var currentTrivia = NumberTriviaModel.fromJson(t);
        if (currentTrivia.number == number) {
          return currentTrivia;
        }
      }

      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  NumberTriviaModel getRandomNumberTrivia() {
    var response = sharedPreferences.getStringList(listTrivias);

    if (response != null && response.isNotEmpty) {
      return NumberTriviaModel.fromJson(
          response[Random().nextInt(response.length)]);
    } else {
      throw CacheException();
    }
  }
}
