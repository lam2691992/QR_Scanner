import 'package:flutter/material.dart';

import 'generated_instargram_screen.dart';

class InstagramScreen extends StatefulWidget {
  const InstagramScreen({super.key});

  @override
  State<InstagramScreen> createState() => _InstagramScreenState();
}

class _InstagramScreenState extends State<InstagramScreen> {
  final TextEditingController _controller = TextEditingController();
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentLength = _controller.text.length;
      });
    });
  }

  void _generateQRCode() {
    final inputText = _controller.text.trim();
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter text before generating QR code!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Kiểm tra định dạng URL
    final uri = Uri.tryParse(inputText);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please enter a valid URL (must start with http:// or https://)!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Kiểm tra URL có thuộc về FB hay không
    if (!(uri.host.contains('instagram.com'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid Instagram URL!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Nếu URL hợp lệ và thuộc về Instagram, chuyển sang màn hình hiển thị QR code
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratedInstagramScreen(
          data: inputText,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130), // Tăng chiều cao AppBar
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
                      "Instagram",
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter your profile link",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      TextFormField(
                        controller: _controller,
                        maxLines: 10,
                        decoration: InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          counterText: "",
                          labelText: "Text here...",
                          labelStyle:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLength: 300,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 12,
                        child: Text(
                          "$_currentLength/300",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                    ],
                  ),
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
                onPressed: _generateQRCode,
                child: const Text(
                  "Generate",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
