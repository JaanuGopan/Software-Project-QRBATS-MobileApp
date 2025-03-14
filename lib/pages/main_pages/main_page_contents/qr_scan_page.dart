import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrbats_sp/api_services/EventService.dart';
import 'package:qrbats_sp/api_services/LectureAttendanceService.dart';
import 'package:qrbats_sp/api_services/MerkAttendanceService.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/components/scanqrcode_components/scanned_event_component.dart';
import 'package:qrbats_sp/components/scanqrcode_components/scanned_module_component.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class QRCodeScan extends StatefulWidget {
  const QRCodeScan({super.key});

  @override
  State<QRCodeScan> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  late int studentId;

  @override
  void initState() {
    super.initState();
  }

  String? result;
  LectureQRCodeDetails? qrCodeDetails;
  EventQRCodeDetails? scannedEventQRCodeDetails;
  bool showEventQrCodeDetails = false;
  Module? scannedModule;
  bool showQRCodeDetails = false;
  bool showScannedModule = false;
  bool showScannedDetails = false;
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
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    getLocation();
  }

  Future<void> scanQRCode() async {
    try {
      setState(() {
        showScannedModule = false;
        scannedModule = null;
        showScannedDetails = false;
        showQRCodeDetails = false;
        showEventQrCodeDetails = false;
        scannedEventQRCodeDetails = null;
      });

      result = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );

      debugPrint("Scanned QR Code: $result");

      if (result != null && result != "-1") {
        try {
          Map<String, dynamic> details = json.decode(result!);

          if (details.containsKey('eventId') && details['eventId'] != null) {
            String scannedEventId = details['eventId'].toString();
            if (scannedEventId.isNotEmpty) {
              getEvent(int.parse(scannedEventId));
              setState(() {
                showScannedDetails = true;
              });
            }
          } else if (details.containsKey('moduleCode') &&
              details['moduleCode'] != null) {
            String scannedModuleCode = details['moduleCode'];
            if (scannedModuleCode.isNotEmpty) {
              getModule(scannedModuleCode);
              setState(() {
                qrCodeDetails = LectureQRCodeDetails.fromJson(details);
                showQRCodeDetails = true;
              });
            }
          } else {
            CustomSnackBar.showError(context, "Scanned QR Code is not valid.");
          }
        } catch (e) {
          debugPrint("Error parsing QR code data: $e");
          CustomSnackBar.showError(context, "Error parsing QR code data.");
        }
      } else {
        CustomSnackBar.showError(context, "Scanning canceled or failed.");
      }
    } on PlatformException {
      result = "Failed to scan QR Code.";
      CustomSnackBar.showError(context, result!);
    }
    if (!mounted) return;
    debugPrint("THE RESULT IS $result");
  }

  Future<void> getModule(String moduleCode) async {
    Module module =
        await ModuleService.getModuleByModuleCode(context, moduleCode);
    setState(() {
      scannedModule = module;
      showScannedModule = true;
    });
    print(module.toString());
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

  Future<void> getEvent(int eventId) async {
    try {
      EventQRCodeDetails eventQRCodeDetails =
          await EventService.getEventByEventId(context, eventId);

      setState(() {
        scannedEventQRCodeDetails = eventQRCodeDetails;
        showEventQrCodeDetails = true;
      });
    } on Exception catch (e) {
      // TODO
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
              const SizedBox(height: 20),
              const Text(
                "Scan QR Code to Mark Attendance",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth * 0.8,
                margin: EdgeInsets.only(
                    left: screenWidth * 0.07, right: screenWidth * 0.07),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: const Border(
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
                    const Spacer(),
                    Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage(
                              "lib/assets/qrcode/barcode-scanner.png"),
                          height: 70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                        onPressed: () {
                          checkLocationPermission();
                          scanQRCode();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF086494)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Scan QR Code",
                          style: TextStyle(color: Color(0xFF086494)),
                        )),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (showQRCodeDetails && qrCodeDetails != null)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        showScannedModule
                            ? Container(
                                width: screenWidth * 0.9,
                                child: ScannedModule(
                                  module: scannedModule!,
                                  studentId: studentId,
                                ))
                            : const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ],
                ),
              showEventQrCodeDetails && scannedEventQRCodeDetails != null
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ScannedEvent(
                                  event: scannedEventQRCodeDetails!,
                                  studentId: studentId),
                            ),
                          ],
                        )
                      ],
                    )
                  : showScannedDetails
                      ? const Center(child: CircularProgressIndicator())
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
