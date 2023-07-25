import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthRepository {
  LocalAuthRepository._();

  /// Singleton instance of [LocalAuthRepository].
  static final instance = LocalAuthRepository._();

  /// initialize Local Authentication plugin.
  final LocalAuthentication localAuthentication = LocalAuthentication();

  /// check if device supports biometrics authentication.
  Future<bool> isDeviceSupported() async {
    return await localAuthentication.isDeviceSupported();
  }

  Future<bool> authenticateUser() async {
    /// status of authentication.
    bool isAuthenticated = false;

    bool isBiometricSupported = await isDeviceSupported();

    /// check if user has enabled biometrics.
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    /// if device supports biometrics and user has enabled biometrics, then authenticate.
    if (isBiometricSupported || canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: translate('security.biometric_auth_message'),
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } on PlatformException catch (e) {
        debugPrint('$e');
      }
    }
    return isAuthenticated;
  }
}
