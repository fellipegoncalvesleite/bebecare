import 'package:geolocator/geolocator.dart';

/// What happened when we asked for the device location.
enum LocationOutcome { success, serviceDisabled, denied, deniedForever, error }

class LocationResult {
  const LocationResult(this.outcome, [this.position]);

  final LocationOutcome outcome;
  final Position? position;

  bool get isSuccess => outcome == LocationOutcome.success && position != null;
}

/// Thin wrapper over geolocator that resolves every failure mode explicitly so
/// the UI never hangs or shows an empty screen.
class LocationService {
  const LocationService();

  Future<LocationResult> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult(LocationOutcome.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationOutcome.deniedForever);
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult(LocationOutcome.denied);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      return LocationResult(LocationOutcome.success, position);
    } catch (_) {
      return const LocationResult(LocationOutcome.error);
    }
  }

  /// Opens the OS settings so the user can re-enable a permanently denied
  /// permission.
  Future<void> openSettings() => Geolocator.openAppSettings();
}
