import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/utils/icons/copy_qr_code.dart';
import 'package:qr_scanner/widgets/share_qr_code.dart';
import '../../widgets/custom_colors.dart';
import '../../widgets/get_formatted_data.dart';
import '../../widgets/save_qr_code.dart';

class GeneratedTextScreen extends StatelessWidget {
  final String data;
  final GlobalKey _globalKey = GlobalKey();
  GeneratedTextScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.orange),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Text",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 20),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => shareQrCode(context, _globalKey),
                          icon:
                              const Icon(Icons.ios_share, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () async {
                            await saveQrCode(_globalKey, context);
                          },
                          icon:
                              const Icon(Icons.download, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Text(
                      "QR Code",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color:
                      Theme.of(context).extension<CustomColors>()?.qrBackground,
                  padding: const EdgeInsets.all(20),
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: 300.0,
                    gapless: false,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      getFormattedData(data),
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  CopyIconButton(data: data),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
