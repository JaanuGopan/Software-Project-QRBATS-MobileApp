import 'package:flutter/material.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';

import '../components/buttons/button_white.dart';
import 'login_signup_pages/signup_page1.dart';

class OpeningPage extends StatefulWidget {
  const OpeningPage({super.key});

  @override
  State<OpeningPage> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  void getStart() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final themeColour = Color(0xFF086494);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  child: Text(
                    "W E L C O M E",
                    style: TextStyle(
                      color: themeColour,
                      fontSize: screenHeight * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Image(
                  image: AssetImage("lib/assets/logo/logo.png"),
                  height: screenHeight * 0.3,
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: themeColour,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100.0),
                      bottomLeft: Radius.circular(100.0),
                    ),
                  ),
                  height: screenHeight * 0.3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 35,
                          ),
                          child: Text(
                            "This is the best app to take Attendance using QR code with GPS tracking",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.02,
                            ),
                          ),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              getStart();
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Get Start",
                              style: TextStyle(color: Color(0xFF086494),fontWeight: FontWeight.bold,fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
