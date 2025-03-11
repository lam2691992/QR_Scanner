import 'package:flutter/material.dart';
import 'generated_wifi_screen.dart';
import '../../widgets/sliding_selector_security_wifi.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHidden = false;
  int selectedSecurityIndex = 0; // 0: WPA/WPA2, 1: WEP, 2: None

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Xây dựng chuỗi QR Code theo chuẩn WiFi:
  /// WIFI:T:<encryption>;S:<ssid>;P:<password>;H:<hidden>;;
  void _generateWifiQRCode() {
    String ssid = _ssidController.text.trim();
    String password = _passwordController.text.trim();

    if (ssid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your SSID")),
      );
      return;
    }

    // Nếu bảo mật khác "None" (index 2) thì mật khẩu phải được nhập
    if (selectedSecurityIndex != 2 && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your Password")),
      );
      return;
    }

    // Xác định kiểu mã hóa
    String encryption;
    String qrData;
    String hiddenStr = isHidden ? "true" : "false";

    if (selectedSecurityIndex == 0) {
      encryption = "WPA";
      qrData = "WIFI:T:$encryption;S:$ssid;P:$password;H:$hiddenStr;;";
    } else if (selectedSecurityIndex == 1) {
      encryption = "WEP";
      qrData = "WIFI:T:$encryption;S:$ssid;P:$password;H:$hiddenStr;;";
    } else {
      // Nếu kiểu bảo mật là "None", không thêm mật khẩu
      qrData = "WIFI:S:$ssid;H:$hiddenStr;;";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratedWifiScreen(data: qrData),
      ),
    );
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
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Wifi",
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Name (SSID)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ssidController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your SSID',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    // Nếu không chọn "None" thì hiển thị trường Password
                    if (selectedSecurityIndex != 2) ...[
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your Password',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 16, color: Colors.grey),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 27),
                    // Chọn loại bảo mật
                    Text(
                      'Security',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SlidingSecuritySelector(
                        labels: const ['WPA/WPA2', 'WEP', 'None'],
                        initialIndex: selectedSecurityIndex,
                        onSelected: (index) {
                          setState(() {
                            selectedSecurityIndex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Chọn ẩn SSID (Hidden)
                    Container(
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Hidden',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Switch(
                              value: isHidden,
                              onChanged: (bool value) {
                                setState(() {
                                  isHidden = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _generateWifiQRCode,
                  child: const Text(
                    "Generate",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
