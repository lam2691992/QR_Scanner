import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool> authenticateWithBiometrics() async {
  bool didAuthenticate = false;

  try {
    // Kiểm tra thiết bị có thể dùng biometrics không
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      // Nếu không có cảm biến biometrics, return false
      return false;
    }

    // Danh sách biometrics có sẵn
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    // Nếu muốn chắc chắn Face ID (trên iOS) hoặc fallback vân tay
    if (availableBiometrics.contains(BiometricType.face) ||
        availableBiometrics.contains(BiometricType.fingerprint)) {
      // Yêu cầu xác thực
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to enable Face ID login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    }
  } catch (e) {
    print("Error using biometrics: $e");
  }

  return didAuthenticate;
}
