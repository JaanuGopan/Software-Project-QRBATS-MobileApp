import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_one/second_page.dart';
import 'package:lottie/lottie.dart';
/*
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //
  @override
  void initState() {
    super.initState();

    // Add a delay and then navigate to the next page
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => second_page()),
      );
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: h / 5,
                //width: w,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  child: Text(
                    "Wellcome",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  height: h / 2.5,
                  width: w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo.jpeg"))),
                ),
              ),
              Container(
                height: h / 3,
                width: w,
                //color: Colors.deepPurpleAccent,
                decoration: BoxDecoration(
                    color: Colors.indigo[900],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  children: [
                    Lottie.asset('assets/loading.json',
                        width: 200, height: 200, fit: BoxFit.fill),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 40,
                        left: 40,
                      ),
                      child: Text(
                        "This is the best app to take attendance using QR code with GPS tracking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
