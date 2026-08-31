import 'package:elminiawy/core/common/shared/shared_imports.dart'; // Import shared utilities

class ConnectivityController {
  /// Private constructor
  ConnectivityController._();

  /// Static instance
  static final ConnectivityController instance = ConnectivityController._();

  /// StreamController to connect with internet
  final StreamController<bool> _connectivityStreamController =
      StreamController<bool>.broadcast();

  /// Getter to Stream
  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  /// Initialize connectivity monitoring
  Future<void> init() async {
    final result = await Connectivity().checkConnectivity();

    _updateConnectivityStatus(result);
    Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  /// Handle connectivity changes
  void _updateConnectivityStatus(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _connectivityStreamController.sink.add(false);
    } else {
      // Treat any other state (mobile, wifi, ethernet, bluetooth, vpn, other) as connected
      _connectivityStreamController.sink.add(true);
    }
  }


  /// Close the controller
  void close() {
    _connectivityStreamController.close();
  }
}
