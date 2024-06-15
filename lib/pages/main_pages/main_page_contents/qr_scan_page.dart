import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/LectureAttendanceService.dart';
import 'package:qrbats_sp/api_services/LocationService.dart';
import 'package:qrbats_sp/api_services/MerkAttendanceService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/components/buttons/button_dark_small.dart';
import 'package:qrbats_sp/components/texts/TextBlue.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeScan extends StatefulWidget {
  final String token;

  const QRCodeScan({Key? key, this.token = ""}) : super(key: key);

  @override
  State<QRCodeScan> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  late int studentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
  }

  String? result;
  LectureQRCodeDetails? qrCodeDetails;
  bool showQRCodeDetails = false;
  double latitude = 0.0;
  double longitude = 0.0;
  double distance = 99999;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    print('Latitude: ${position.latitude}');
    print('Longitude: ${position.longitude}');
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case when location permission is denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle case when location permission is permanently denied
      return;
    }

    getLocation(); // Permission granted, get the location
  }

  /* // Replace this key with your decryption key (32 bytes for AES-256)

  QRCodeDetails? decryptQRCodeData(String encryptedData)  {
    final key = encrypt.Key.fromUtf8('uDhHvDXPKJUJSMVdx8JSYamDTu18iLTVTzg/Ohy05no=');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    qrCodeDetails = QRCodeDetails.fromJson(jsonDecode(decrypted));
    return qrCodeDetails;
    */ /*setState(() {
      qrCodeDetails = QRCodeDetails.fromJson(jsonDecode(decrypted));
      showQRCodeDetails = true;
    });*/ /*
  }*/

  Future<void> scanQRCode() async {
    try {
      result = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "cancel",
        true,
        ScanMode.QR,
      );
      debugPrint("Scanned QR Code: $result");
      if (result != null) {
        setState(() {
          try {
            setState(() {
              qrCodeDetails =
                  LectureQRCodeDetails.fromJson(jsonDecode(result!));
              showQRCodeDetails = true;
            });
            //getLocationDistance(qrCodeDetails!.eventVenue, latitude, longitude);
          } catch (e) {
            debugPrint("Error parsing QR code data: $e");
          }
        });
      }
    } on PlatformException {
      result = "not scan";
    }
    if (!mounted) return;
    print("THE RESULT IS $result");
  }

  Future<void> markAttendance(int eventID, int attendeeID, double latitude,
      double longitude, BuildContext context) async {
    bool isCloseDetails = await MarkAttendanceService.markAttendance(
        eventID, attendeeID, latitude, longitude, context);
    if (isCloseDetails) {
      setState(() {
        showQRCodeDetails = false;
      });
    }
  }

  Future<void> markLectureAttendance(int studentId, String moduleCode,
      double latitude, double longitude, BuildContext context) async {
    bool isCloseDetails = await LectureAttendanceService.markLectureAttendance(
        studentId, moduleCode, latitude, longitude, context);
    if (isCloseDetails) {
      setState(() {
        showQRCodeDetails = false;
      });
    }
  }

  /*Future<void> getLocationDistance(String locationName, double latitude,double longitude) async {
    await checkLocationPermission();
    double calcdistance = await LocationService.findLocationDistance(locationName, latitude, longitude);
    print("distance"+ calcdistance.toString());
    setState(() {
      print(calcdistance);
      distance = calcdistance;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Scan QR Code to Mark Attendance",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.8,
                margin: EdgeInsets.only(
                    left: screenWidth * 0.07, right: screenWidth * 0.07),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF086494),
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Color(0xFF086494),
                      width: 1.0,
                    ),
                    left: BorderSide(
                      color: Color(0xFF086494),
                      width: 1.0,
                    ),
                    right: BorderSide(
                      color: Color(0xFF086494),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage(
                              "lib/assets/qrcode/barcode-scanner.png"),
                          height: 70,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () {
                          checkLocationPermission();
                          scanQRCode();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF086494)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(color: Color(0xFF086494)),
                        )),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (showQRCodeDetails && qrCodeDetails != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("QRCode Details"),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (qrCodeDetails!.moduleCode != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Module : "),
                          Text(qrCodeDetails!.moduleCode ?? ''),
                        ],
                      ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Spacer(),
                        OutlinedButton(
                            onPressed: () {
                              getLocation();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.orange),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Refresh Location",
                              style: TextStyle(color: Colors.orange),
                            )),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Distance : "),
                        Text("${distance.toStringAsFixed(3)} m"),
                        SizedBox(
                          width: 10,
                        ),
                        if (distance <= 30.0)
                          const Icon(
                            CupertinoIcons.checkmark_alt,
                            color: Colors.green,
                          ),
                        if (distance > 30.0)
                          const Icon(
                            CupertinoIcons.multiply,
                            color: Colors.red,
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //if (distance <= 30.0)
                    OutlinedButton(
                        onPressed: () {
                          markLectureAttendance(
                            studentId,
                            qrCodeDetails!.moduleCode,
                            latitude,
                            longitude,
                            context,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Mark Attendance",
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
