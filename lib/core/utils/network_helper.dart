import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static late final Connectivity _connectivity;

  static void init() {
    _connectivity = Connectivity();
  }

  static Future<bool> get isConnected async =>
      !(await _connectivity.checkConnectivity())
          .contains(ConnectivityResult.none);
}
