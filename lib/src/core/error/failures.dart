import 'package:equatable/equatable.dart';

//Modelo padrão para erros futuros
abstract class Failure extends Equatable{
  final List properties = const<dynamic>[];

  @override
  List<Object> get props => [properties];

  const Failure([properties]) ;
}
//General Failures
class ServerFailure extends Failure{}

class CacheFailure extends Failure{}