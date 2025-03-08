import 'package:flutter/material.dart';

import 'generated_email_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  // Controller cho nội dung tin nhắn (body)
  final TextEditingController _controller = TextEditingController();
  // Controller cho trường "To"
  final TextEditingController _recipientController = TextEditingController();
  // Controller cho trường "Subject"
  final TextEditingController _subjectController = TextEditingController();
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
    final recipient = _recipientController.text.trim();
    final subject = _subjectController.text.trim();
    final body = _controller.text.trim();

    // Kiểm tra xem cả 3 trường có được nhập đầy đủ không
    if (recipient.isEmpty || subject.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter Recipient, Subject, and Message!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Định dạng data theo chuẩn mailto:
    final formattedData =
        'MATMSG:TO:$recipient;SUB:${Uri.encodeComponent(subject)};BODY:${Uri.encodeComponent(body)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratedEmailScreen(
          data: formattedData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _recipientController.dispose();
    _subjectController.dispose();
    super.dispose();
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
                      "Email",
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
                    const SizedBox(height: 10),
                    Text(
                      'Enter your Mail',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      style: Theme.of(context).textTheme.bodyLarge,
                      controller: _recipientController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'To',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      style: Theme.of(context).textTheme.bodyLarge,
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Subject',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        TextFormField(
                          controller: _controller,
                          maxLines: 10,
                          decoration: InputDecoration(
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
                                  ?.copyWith(fontSize: 16, color: Colors.grey),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
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
      ),
    );
  }
}
