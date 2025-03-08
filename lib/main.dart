import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'utils/custom_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // Hàm cập nhật theme
  void _changeTheme(ThemeMode newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
      themeMode: _themeMode,
      // Định nghĩa theme cho chế độ light
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Màu nền ứng dụng
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Màu nền AppBar
          foregroundColor: Colors.black, // Màu chữ AppBar
        ),
        cardColor: Colors.grey[200],
        iconTheme: const IconThemeData(
          color: Colors.black, // Màu nền icon
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 20),        
        ),
        extensions: <ThemeExtension<dynamic>>[
      CustomColors(qrBackground: Colors.grey[300]),
    ],
      ),
      // Định nghĩa theme cho chế độ dark
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Màu nền ứng dụng
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Màu nền AppBar
          foregroundColor: Colors.white, // Màu chữ AppBar
        ),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.grey[800]),
        cardColor: Colors.grey[800],
        iconTheme: const IconThemeData(
          color: Colors.white, // Màu nền icon
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.white, fontSize: 20), // Màu nền Text
        ),
        extensions:const <ThemeExtension<dynamic>>[
      CustomColors(qrBackground: Colors.white),
    ],
      ),
      // Truyền callback _changeTheme xuống HomeScreen
      home: HomeScreen(onThemeChanged: _changeTheme),
    );
  }
}
