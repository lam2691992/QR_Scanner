import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

final LocalAuthentication auth = LocalAuthentication();

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitchOn = false;
  bool hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  // Kiểm tra thiết bị có hỗ trợ biometrics không
  Future<void> _checkBiometrics() async {
    try {
      final bool canCheck = await auth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (canCheck &&
          (availableBiometrics.contains(BiometricType.face) ||
              availableBiometrics.contains(BiometricType.fingerprint))) {
        setState(() {
          hasBiometrics = true;
        });
      } else {
        setState(() {
          hasBiometrics = false;
        });
      }
    } catch (e) {
      print("Error checking biometrics: $e");
      setState(() {
        hasBiometrics = false;
      });
    }
  }

  // Xác thực biometrics
  Future<bool> authenticateWithBiometrics() async {
    bool didAuthenticate = false;
    try {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.fingerprint)) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.orange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(color: Colors.orange, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Settings",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Divider(
            thickness: 0.3,
            color: Colors.black,
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0, right: 18),
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.orange,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        'Choose your mode',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).iconTheme.color, size: 18),
                        onPressed: () async {
                          final chosenTheme = await showDialog<ThemeMode>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                backgroundColor: Colors.grey[100],
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(
                                        context, ThemeMode.system),
                                    child: const Text(
                                      "Auto",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.3,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () =>
                                        Navigator.pop(context, ThemeMode.light),
                                    child: const Text(
                                      "Light",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.3,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () =>
                                        Navigator.pop(context, ThemeMode.dark),
                                    child: const Text(
                                      "Dark",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          // Nếu người dùng đã chọn một theme, gọi callback để cập nhật giao diện
                          if (chosenTheme != null) {
                            widget.onThemeChanged(chosenTheme);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (hasBiometrics)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0, right: 18),
                          child: Icon(
                            Icons.qr_code_rounded,
                            color: Colors.orange,
                            size: 24.0,
                          ),
                        ),
                        Text(
                          'Touch/Face ID',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isSwitchOn,
                              onChanged: (value) async {
                                if (value) {
                                  // Người dùng bật switch => yêu cầu xác thực
                                  bool success =
                                      await authenticateWithBiometrics();
                                  if (success) {
                                    setState(() {
                                      isSwitchOn = true;
                                    });
                                  } else {
                                    setState(() {
                                      isSwitchOn = false;
                                    });
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Authentication failed or not available"),
                                      ),
                                    );
                                  }
                                } else {
                                  // Người dùng tắt switch
                                  setState(() {
                                    isSwitchOn = false;
                                  });
                                }
                              },
                              activeColor: Colors.orange,
                              inactiveTrackColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18),
                            child: Icon(
                              Icons.sticky_note_2_outlined,
                              color: Colors.orange,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Terms of Use',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              final Uri url = Uri.parse(
                                  'https://www.hhhtechnologies.com/terms-and-conditions');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not launch $url'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.3,
                        indent: 60,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18),
                            child: Icon(
                              Icons.privacy_tip,
                              color: Colors.orange,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Privacy Policy',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              final Uri url = Uri.parse(
                                  'https://www.hhhtechnologies.com/privacy-policy');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not launch $url'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18),
                            child: Icon(
                              Icons.textsms,
                              color: Colors.orange,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Get Help',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              // Tạo Uri mailto
                              final Uri mailUri = Uri(
                                scheme: 'mailto',
                                path: 'support@netron.solutions',
                                query: _encodeQueryParameters(<String, String>{
                                  'subject': 'Netron | QR Code - Support',
                                  'cc': 'lam269.lnv@gmail.com',
                                }),
                              );
                              // Kiểm tra có mở được mail app không
                              if (await canLaunchUrl(mailUri)) {
                                await launchUrl(mailUri);
                              } else {
                                // Xử lý trường hợp không mở được
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not open mail app.'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.3,
                        indent: 60,
                        // endIndent: 20,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18),
                            child: Icon(
                              Icons.ios_share,
                              color: Colors.orange,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Share App',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                            onPressed: () {
                              const String appLink = 'https://app-link.com';
                              Share.share(appLink,
                                  subject: 'Check out this app!');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
