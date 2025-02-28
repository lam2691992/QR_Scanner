import 'package:flutter/material.dart';

import 'generated_barcode_screen.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final TextEditingController _controller = TextEditingController();
  int _currentLength = 0;
  String _selectedBarcodeType = 'Select barcode type';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentLength = _controller.text.length;
      });
    });
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
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Barcode",
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _showBarcodeTypeSelection(context);
                        },
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedBarcodeType,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 14, color: Colors.grey),
                              ),
                              const Spacer(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _showBarcodeTypeSelection(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 200,
                        ),
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _controller,
                              maxLines: 10,
                              decoration: InputDecoration(
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                counterText: "",
                                label: Text(
                                  "Text here...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontSize: 16, color: Colors.grey),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
                  onPressed: () {
                    String inputData = _controller.text.trim();

                    if (inputData.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter some text")),
                      );
                      return;
                    }

                    if (_selectedBarcodeType == 'Select barcode type') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please select a barcode type")),
                      );
                      return;
                    }

                    if (_selectedBarcodeType == "Code 93") {
                      inputData = inputData.toUpperCase();
                      RegExp validPattern = RegExp(r'^[A-Z0-9 \-\.\$\+\/%]+$');
                      if (!validPattern.hasMatch(inputData)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Invalid characters for Code 93.\nUse only uppercase letters, digits, and - . \$ / + %."),
                          ),
                        );
                        return;
                      }
                    }

                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GeneratedBarcodeScreen(
                            data: inputData,
                            barcodeType: _selectedBarcodeType,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error generating barcode: $e")),
                      );
                    }
                  },
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

  void _showBarcodeTypeSelection(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Done",
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Center(
                    child: Text(
                      "Code 93",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("Code 93");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "Code 39",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("Code 39");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "CODABAR",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("CODABAR");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "Code 128",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("Code 128");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "EAN-13",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("EAN-13");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "EAN-8",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("EAN-8");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "UPC-A",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("UPC-A");
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      "UPC-E",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop("UPC-E");
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          _selectedBarcodeType = selectedValue;
        });
      }
    });
  }
}
