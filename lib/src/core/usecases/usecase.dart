import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

//Modelo padrão de um UseCase
abstract class Usecase<ReturnType, Params> {
  Future<Either< Failure, ReturnType>> call(Params params) ;
}

//Parametros para serem passados caso não tenha parametros
class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}