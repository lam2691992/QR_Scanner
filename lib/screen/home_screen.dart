import 'package:flutter/material.dart';
import 'package:qr_scanner/database/database_helper.dart';
import 'package:qr_scanner/screen/qr_scanner_screen.dart';
import 'package:qr_scanner/screen/setting_screen.dart';
import '../widgets/custom_page_route.dart';
import '../widgets/url_launcher.dart';
import 'menu_code_generator.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> scanHistory = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    final history = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      scanHistory = history;
    });
  }

  // Mở màn hình quét QR, sau khi quét xong lưu dữ liệu vào database và reload danh sách.
  void _launchQRScanner() {
    if (isScanning) return; // Ngăn mở nhiều lần

    isScanning = true;
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onQRScanned: (String scannedData) async {
            // Kiểm tra xem context có còn tồn tại không
            if (!context.mounted) return;

            // Lưu dữ liệu quét vào database
            await DatabaseHelper.instance.insert({
              DatabaseHelper.columnScanData: scannedData,
              DatabaseHelper.columnTimestamp:
                  DateTime.now().millisecondsSinceEpoch,
            });

            // Reload lịch sử quét từ database
            await _loadScanHistory();

            // Kiểm tra context trước khi hiển thị SnackBar
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Scan saved: $scannedData")),
            );
          },
        ),
      ),
    )
        .then((_) {
      isScanning = false;
    });
  }

  void _openHistoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            HistoryScreen(scanHistory: scanHistory), // Truyền scanHistory
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu của mã QR mới nhất nếu có
    String? firstScanData;
    if (scanHistory.isNotEmpty) {
      firstScanData = scanHistory.first[DatabaseHelper.columnScanData];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          onThemeChanged: widget.onThemeChanged,
                        )),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: IconButton(
              icon: const Icon(Icons.qr_code_scanner,
                  size: 80, color: Colors.blue),
              onPressed: _launchQRScanner,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Tap to scan QR Code",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          // Hiển thị nội dung của mã QR mới nhất (nếu có)
          if (firstScanData != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Scanned Data: $firstScanData",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
          if (firstScanData != null &&
              Uri.tryParse(firstScanData)?.hasAbsolutePath == true)
            ElevatedButton(
              onPressed: () => launchURL(firstScanData!),
              child: const Text("Open Browser"),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _openHistoryScreen,
                child: Text(
                  "History",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(createPageRoute(const CodeGeneratorScreen()));
                },
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
