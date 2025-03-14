import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/logout_popup/logout_popup.dart';
import 'package:qrbats_sp/pages/getStart_page.dart';
import 'package:qrbats_sp/pages/main_pages/main_page_contents/attendance_history_page.dart';
import 'package:qrbats_sp/pages/main_pages/main_page_contents/module_page.dart';
import 'package:qrbats_sp/pages/main_pages/main_page_contents/profile_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page_contents/home_page.dart';
import 'main_page_contents/qr_scan_page.dart';

class MainPage extends StatefulWidget {
  final int pageIndex;
  final String token;
  const MainPage({Key? key, this.pageIndex = 2, this.token = ""})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String userName;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userName = jwtDecodedToken["firstName"];
    _currentIndex = widget.pageIndex;
  }

  void _logout() async {
    // Clear the authentication token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    // Navigate to the starting page (login page)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OpeningPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add your other pages to this list
    List<Widget> pages = [
      const Home(),
      const ModulePage(),
      const QRCodeScan(),
      const AttendanceHistoryPage(),
      const ProfileSettingPage(),
      //SettingPage(token: widget.token,)
      // Add more pages as needed
    ];

    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xFF086494),
          title: const Center(
            child: Text(
              "Sky Ticker",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                showLogoutPopup(context, () => _logout());
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: _drawerWidget(context),
        endDrawer: const Drawer(
            // Add content for endDrawer
            ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF086494),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: 'Module',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR-Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: pages[_currentIndex],
      ),
    );
  }

  Drawer _drawerWidget(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF086494),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      color: Color(0xFF086494),
                      size: 80,
                    ),
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.lightbulb,
              color: Color(0xFF086494),
              size: 35,
            ),
            title: const Text(
              'About Us',
              style: TextStyle(color: Color(0xFF086494), fontSize: 20),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About Us'),
                    content: const Text(
                      'Skyticker is a smart QR-based attendance tracking app designed to simplify and automate attendance management '
                      'with fast QR scanning and real-time tracking, ensuring accuracy and efficiency. Developed by 22nd Computer Engineering '
                      'batch students—Janugopan S, Harintharan N, Sivakkanth K, and Dilexan H.A.L.—this app aims to digitalize the attendance '
                      'marking system at the University of Ruhuna, Faculty of Engineering, making the process seamless and modern.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xFF086494),
              size: 35,
            ),
            title: const Text('Logout',
                style: TextStyle(color: Color(0xFF086494), fontSize: 20)),
            onTap: () {
              showLogoutPopup(context, () => _logout());
            },
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}
