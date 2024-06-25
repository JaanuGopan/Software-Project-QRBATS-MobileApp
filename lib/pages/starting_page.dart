import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'getStart_page.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void initState() {
    super.initState();

    // Add a delay and then navigate to the next page
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OpeningPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: h * 0.3,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.05),
                  child: Text(
                    "W E L C O M E",
                    style: TextStyle(
                      fontSize: h * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF086494),
                    ),
                  ),
                ),
              ),
              Container(
                height: h * 0.3,
                width: w * 0.7,
                margin: EdgeInsets.only(bottom: h * 0.05),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/logo/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: h * 0.3,
                width: w,
                padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                decoration: BoxDecoration(
                  color: Color(0xFF086494),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'lib/assets/loading/loading1.json',
                      width: w * 0.5,
                      height: h * 0.15,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                      child: Text(
                        "This is the best app to take attendance using QR code with GPS tracking",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
