import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

///Interface for checking internet connectivity
abstract interface class ConnectionChecker {
  ///Method to get connection status
  Future<bool> get isConnected;
}

///Implemenentation of [ConnectionChecker]
class ConnectionCheckerImpl implements ConnectionChecker {
  ///
  ConnectionCheckerImpl(this.internetConnection);

  ///
  final InternetConnection internetConnection;

  @override
  Future<bool> get isConnected async => internetConnection.hasInternetAccess;
}
