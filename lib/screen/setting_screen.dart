import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
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
                                // Người dùng vừa bật switch => Yêu cầu xác thực
                                bool success =
                                    await authenticateWithBiometrics();
                                if (success) {
                                  setState(() {
                                    isSwitchOn = true; // Bật thành công
                                  });
                                } else {
                                  // Không xác thực được => không bật switch
                                  setState(() {
                                    isSwitchOn = false;
                                  });
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Authentication failed or not available")),
                                  );
                                }
                              } else {
                                // Người dùng tắt switch => tắt Face ID
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
                              final Uri url =
                                  Uri.parse('https://www.google.com');
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
                            onPressed: () {
                              // Thực hiện hành động khi nhấn vào mũi tên
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
                            onPressed: () {
                              // Thực hiện hành động khi nhấn vào mũi tên
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
                              // Thực hiện hành động khi nhấn vào mũi tên
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
