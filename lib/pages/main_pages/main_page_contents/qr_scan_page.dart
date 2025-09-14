import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrbats_sp/api_services/EventService.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/components/scanqrcode_components/scanned_event_component.dart';
import 'package:qrbats_sp/components/scanqrcode_components/scanned_module_component.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:qrbats_sp/utils/CameraUtils.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class QRCodeScan extends StatefulWidget {
  const QRCodeScan({super.key});

  @override
  State<QRCodeScan> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
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

  void _handleOpenCamera() {
    CameraUtils.checkCameraPermissions(context).then((isCameraAuthorized) {
      if (isCameraAuthorized) {
        scanQRCode();
      } else {
        CustomSnackBar.showError(context, "Camera permission is required.");
      }
    }).catchError((error) {
      debugPrint("Error in checking camera permissions: $error");
      CustomSnackBar.showError(
          context, "Error in checking camera permissions.");
    });
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

      /* result = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      ); */

      result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleBarcodeScannerPage(
              scanType: ScanType.qr,
              lineColor: "#086494",
              isShowFlashIcon: true,
              appBarTitle: "Scan QR Code",
              centerTitle: true,
              cancelButtonText: "Close",
            ),
          ));

      handleScannedQRCode(result);
    } on PlatformException {
      CustomSnackBar.showError(context, "Failed to scan QR Code.");
    }
    if (!mounted) return;
    debugPrint("THE RESULT IS $result");
  }

  void handleScannedQRCode(result) {
    setState(() {
      if (result is String) {
        result = result;
      }
    });

    debugPrint("Scanned QR Code: $result");

    if (result != null && result != "-1") {
      try {
        String decodedString = utf8.decode(base64Decode(result!));
        Map<String, dynamic> details = json.decode(decodedString);

        if (details.containsKey('eventId') && details['eventId'] != null) {
          String scannedEventId = details['eventId'].toString();
          if (scannedEventId.isNotEmpty) {
            getEvent(int.parse(scannedEventId));
            setState(() {
              showScannedDetails = true;
            });
          }
        } else if (details.containsKey('moduleId') &&
            details['moduleId'] != null) {
          int scannedModuleId = details['moduleId'];
          debugPrint("Module ID: $scannedModuleId");
          getModule(scannedModuleId).then((value) => {
                setState(() {
                  qrCodeDetails = LectureQRCodeDetails.fromJson(details);
                  showQRCodeDetails = true;
                })
              });
        } else {
          CustomSnackBar.showError(context, "Scanned QR Code is not valid.");
        }
      } catch (e) {
        debugPrint(
            "The scanned QR code format is not supported by this app: $e");
        CustomSnackBar.showError(context,
            "The scanned QR code format is not supported by this app.");
      }
    } else {
      CustomSnackBar.showError(context, "Scanning canceled or failed.");
    }
  }

  Future<void> getModule(int moduleId) async {
    Module module =
        await ModuleService.getModuleByModuleCode(context, moduleId);
    setState(() {
      scannedModule = module;
      showScannedModule = true;
    });
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
      debugPrint("Error fetching event details: $e");
      CustomSnackBar.showError(context, "Error fetching event details.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image:
                            AssetImage("lib/assets/qrcode/barcode-scanner.png"),
                        height: 70,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _handleOpenCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF086494),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Scan QR Code",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
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
                                ))
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF086494),
                                ),
                              ),
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
                                  event: scannedEventQRCodeDetails!),
                            ),
                          ],
                        )
                      ],
                    )
                  : showScannedDetails
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF086494),
                          ),
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
