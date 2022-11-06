// ignore_for_file: public_member_api_docs, sort_constructors_first
//Modelo de obtenção se existe ou não conexão com a internet
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionCheckerPlus internetConnectionChecker;

  const NetworkInfoImpl(this.internetConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;

}
