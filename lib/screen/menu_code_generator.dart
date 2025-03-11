import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner/screen/music/music_screen.dart';
import 'package:qr_scanner/screen/phone/phone_screen.dart';
import 'package:qr_scanner/screen/pinterest/pinterest_screen.dart';
import 'package:qr_scanner/screen/soundcloud/soundcloud_screen.dart';
import 'package:qr_scanner/screen/spotify/spotify_screen.dart';
import 'package:qr_scanner/screen/text/text_screen.dart';
import 'package:qr_scanner/screen/website/web_screen.dart';
import 'package:qr_scanner/screen/whatsapp/whatsapp_screen.dart';
import 'package:qr_scanner/screen/wifi/wifi_screen.dart';
import 'package:qr_scanner/screen/youtube/youtube_screen.dart';
import '../widgets/custom_page_route.dart';
import 'app_store/appStore_screen.dart';
import 'barcode/barcode_screen.dart';
import 'drive/drive_screen.dart';
import 'dropbox/dropbox_screen.dart';
import 'email/email_screen.dart';
import 'facebook/facebook_screen.dart';
import 'icloud/icloud_screen.dart';
import 'instagram/instagram_screen.dart';
import 'location/location_screen.dart';
import 'message/message_screen.dart';

class CodeGeneratorScreen extends StatelessWidget {
  const CodeGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các mục
    final List<Map<String, dynamic>> categories = [
      {"title": "Barcode", "isHeader": true},
      {"title": "Barcode", "icon": Icons.qr_code, "color": Colors.purple},
      {"title": "General", "isHeader": true},
      {"title": "Text", "icon": Icons.edit, "color": Colors.orange},
      {"title": "Wifi", "icon": Icons.wifi, "color": Colors.teal},
      {"title": "App Store", "icon": Icons.apple, "color": Colors.black},
      {"title": "Communication", "isHeader": true},
      {"title": "Phone", "icon": Icons.phone, "color": Colors.pink},
      {"title": "Email", "icon": Icons.email, "color": Colors.red},
      {"title": "Social", "isHeader": true},
      {
        "title": "Facebook",
        "icon": Icons.facebook,
        "color": Colors.blue.shade800
      },
      {
        "title": "Pinterest",
        "icon": 'asset/pinterest.svg',
      },
      {"title": "Media", "isHeader": true},
      {
        "title": "Youtube",
        "icon": 'asset/youtube.svg',
      },
      {
        "title": "Soundcloud",
        "icon": 'asset/soundcloud.svg',
      },
      {"title": "Cloud", "isHeader": true},
      {"title": "Drive", "icon": 'asset/drive.svg'},
      {"title": "Dropbox", "icon": 'asset/dropbox.svg'},
    ];

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
                      "Code Generator",
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: categories.map<Widget>((category) {
            if (category['isHeader'] == true) {
              return _buildHeader(context, category['title']);
            } else if (category['title'] == "Text") {
              // Nhóm "Text" và "Website" thành 1 hàng
              return _buildRow(
                context,
                category,
                {
                  "title": "Website",
                  "icon": Icons.language,
                  "color": Colors.green,
                },
              );
            } else if (category['title'] == "Wifi") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Location",
                  "icon": Icons.location_on,
                  "color": Colors.blue,
                },
              );
            } else if (category['title'] == "Facebook") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Instagram",
                  "icon": 'asset/instagram.png',
                },
              );
            } else if (category['title'] == "Phone") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Message",
                  "icon": Icons.message,
                  "color": Colors.deepPurple,
                },
              );
            } else if (category['title'] == "Pinterest") {
              return _buildRow(
                context,
                category,
                {
                  "title": "WhatsApp",
                  "icon": 'asset/whatsapp.svg',
                },
              );
            } else if (category['title'] == "Youtube") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Spotify",
                  "icon": 'asset/spotify.svg',
                },
              );
            } else if (category['title'] == "Drive") {
              return _buildRow(
                context,
                category,
                {
                  "title": "iCloud",
                  "icon": 'asset/icloud.png',
                },
              );
            } else if (category['title'] == "Soundcloud") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Music",
                  "icon": Icons.music_note_rounded,
                  "color": Colors.pink,
                },
              );
            } else {
              return buildCategoryCard(context, category);
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> leftItem,
      Map<String, dynamic> rightItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: buildCategoryCard(context, leftItem)),
          const SizedBox(width: 10),
          Expanded(child: buildCategoryCard(context, rightItem)),
        ],
      ),
    );
  }

  Widget buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    bool isSmallCard = category['title'] == "Email" ||
        category['title'] == "Barcode" ||
        category['title'] == "Dropbox" ||
        category['title'] == "App Store";
    double cardWidthFactor = isSmallCard ? 0.5 : 1.0;

    Widget iconWidget;
    if (category['icon'] is String) {
      if (category['icon'].toString().endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          category['icon'],
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        );
      } else {
        iconWidget = Image.asset(
          category['icon'],
          width: 30,
          height: 30,
        );
      }
    } else if (category['icon'] is IconData) {
      iconWidget = Icon(
        category['icon'],
        color: category['color'],
        size: 30,
      );
    } else {
      iconWidget = const SizedBox();
    }

    Widget cardWidget = GestureDetector(
      onTap: () {
        // Điều hướng theo tiêu đề của mục
        if (category['title'] == "Barcode") {
          Navigator.push(
            context,
            createPageRoute(const BarcodeScreen()),
          );
        } else if (category['title'] == "Text") {
          Navigator.push(
            context,
            createPageRoute(const TextScreen()),
          );
        } else if (category['title'] == "Website") {
          Navigator.push(
            context,
            createPageRoute(const WebScreen()),
          );
        } else if (category['title'] == "Wifi") {
          Navigator.push(
            context,
            createPageRoute(const WifiScreen()),
          );
        } else if (category['title'] == "Location") {
          Navigator.push(
            context,
            createPageRoute(LocationScreen()),
          );
        } else if (category['title'] == "App Store") {
          Navigator.push(
            context,
            createPageRoute(const AppStoreScreen()),
          );
        } else if (category['title'] == "Phone") {
          Navigator.push(
            context,
            createPageRoute(const PhoneScreen()),
          );
        } else if (category['title'] == "Message") {
          Navigator.push(
            context,
            createPageRoute(const MessageScreen()),
          );
        } else if (category['title'] == "Email") {
          Navigator.push(
            context,
            createPageRoute(const EmailScreen()),
          );
        } else if (category['title'] == "Facebook") {
          Navigator.push(
            context,
            createPageRoute(const FacebookScreen()),
          );
        } else if (category['title'] == "Instagram") {
          Navigator.push(
            context,
            createPageRoute(const InstagramScreen()),
          );
        } else if (category['title'] == "Pinterest") {
          Navigator.push(
            context,
            createPageRoute(const PinterestScreen()),
          );
        } else if (category['title'] == "WhatsApp") {
          Navigator.push(
            context,
            createPageRoute(const WhatsappScreen()),
          );
        } else if (category['title'] == "Youtube") {
          Navigator.push(
            context,
            createPageRoute(const YoutubeScreen()),
          );
        } else if (category['title'] == "Spotify") {
          Navigator.push(
            context,
            createPageRoute(const SpotifyScreen()),
          );
        } else if (category['title'] == "Soundcloud") {
          Navigator.push(
            context,
            createPageRoute(const SoundcloudScreen()),
          );
        } else if (category['title'] == "Music") {
          Navigator.push(
            context,
            createPageRoute(const MusicScreen()),
          );
        } else if (category['title'] == "Drive") {
          Navigator.push(
            context,
            createPageRoute(const DriveScreen()),
          );
        } else if (category['title'] == "iCloud") {
          Navigator.push(
            context,
            createPageRoute(const IcloudScreen()),
          );
        } else if (category['title'] == "Dropbox") {
          Navigator.push(
            context,
            createPageRoute(const DropboxScreen()),
          );
        }
      },
      child: FractionallySizedBox(
        widthFactor: cardWidthFactor,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: 10),
                Text(
                  category['title'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isSmallCard) {
      return Align(
        alignment: Alignment.centerLeft,
        child: cardWidget,
      );
    }
    return cardWidget;
  }
}
