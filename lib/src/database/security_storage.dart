import 'package:hive_flutter/hive_flutter.dart';

/// Keys for the user's data.
const _pincodeKey = 'pincode';
const _firstTimeKey = 'firstTime';
const _isLocalAuthEnabledKey = 'isLocalAuthEnabled';
const _isBiometricsByUserEnabledKey = 'isBiometricsEnabled';
const _lockTime = 'lockTime';
const _lockDuration = 'lockDuration';

class SecurityStorage {
  SecurityStorage._();

  /// Singleton instance of [StorageModule].
  static final instance = SecurityStorage._();

  /// Local storage for security-related data.
  final Box _localStorage = Hive.box("security_storage");

  /// Getter for the user's pincode.
  String? get pincode => _localStorage.get(_pincodeKey);

  /// Save the user's pincode.
  Future<void> savePincode(String pincode) async {
    await _localStorage.put(_pincodeKey, pincode);
  }

  /// Getter for whether the user has opened the app for the first time.
  bool get isFirstTime => _localStorage.get(_firstTimeKey) ?? true;

  /// Save whether the user has opened the app for the first time.
  Future<void> saveFirstTime(bool isFirstTime) async {
    await _localStorage.put(_firstTimeKey, isFirstTime);
  }

  /// Getter for whether the user has enabled local authentication.
  bool get isLocalAuthEnabled {
    return _localStorage.get(_isLocalAuthEnabledKey) ?? false;
  }

  /// Save the user's choice of whether to enable local authentication.
  Future<void> saveLocalAuthEnabled(bool isLocalAuthEnabled) async {
    await _localStorage.put(_isLocalAuthEnabledKey, isLocalAuthEnabled);
  }

  /// Getter for whether the user has enabled biometrics.
  bool get isBiometricsEnabled {
    return _localStorage.get(_isBiometricsByUserEnabledKey) ?? true;
  }

  /// Save the user's choice of whether to enable biometrics.
  Future<void> saveBiometricsEnabled(bool isBiometricsEnabled) async {
    await _localStorage.put(_isBiometricsByUserEnabledKey, isBiometricsEnabled);
  }

  /// Getter for the time at which the user last left the app.
  DateTime? get lockTime => _localStorage.get(_lockTime);

  /// Save the time at which the user last left the app.
  Future<void> saveLockTime(DateTime lockTime) async {
    await _localStorage.put(_lockTime, lockTime);
  }

  /// Getter for the duration for which the app should be locked in minutes.
  /// -1 means never lock the app
  int? get lockDuration => _localStorage.get(_lockDuration) ?? 5;

  /// Save the duration for which the app should be locked in minutes.
  Future<void> saveLockDuration(int lockDuration) async {
    await _localStorage.put(_lockDuration, lockDuration);
  }

  /// Getter for whether the app should be locked.
  bool get shouldLockApp {
    final lockDuration = this.lockDuration;
    if (lockDuration == -1) {
      return false;
    }
    final lockTime = this.lockTime;
    if (lockTime == null) {
      return false;
    }
    final now = DateTime.now();
    final difference = now.difference(lockTime);
    return difference.inMinutes >= lockDuration!;
  }
}
