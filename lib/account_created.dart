import 'package:flutter/material.dart';
import 'package:good_one/dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:good_one/second_page.dart';

class AccountCreated extends StatefulWidget {
  const AccountCreated({Key? key});

  @override
  _AccountCreatedState createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {
  @override
  void initState() {
    super.initState();
    // Add a delay and then navigate to the next page
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => second_page()), // Replace with your next page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Successfully Created",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img_1.png"),
                    ),
                  ),
                ),
                Lottie.asset(
                  'assets/loading-carga.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
