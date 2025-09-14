import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:skyticker/api/service/EventService.dart';
import 'package:skyticker/api/service/ModuleService.dart';
import 'package:skyticker/components/scanqrcode_components/scanned_event_component.dart';
import 'package:skyticker/components/scanqrcode_components/scanned_module_component.dart';
import 'package:skyticker/models/EnrolledModule.dart';
import 'package:skyticker/models/QRCodeDetails.dart';
import 'package:skyticker/utils/CameraUtils.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;
  QRViewController? qrController;

  void _handleOpenCamera() async {
    CameraUtils.checkCameraPermissions(context)
        .then((isCameraAuthorized) {
          if (isCameraAuthorized) {
            setState(() {
              isScanning = true;
            });
          } else {
            CustomSnackBar.showError(context, "Camera permission is required.");
          }
        })
        .catchError((error) {
          debugPrint("Error in checking camera permissions: $error");
          CustomSnackBar.showError(
            context,
            "Error in checking camera permissions.",
          );
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code != "-1") {
        controller.pauseCamera();
        setState(() {
          isScanning = false;
        });
        handleScannedQRCode(scanData.code);
      }
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
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
          getModule(scannedModuleId).then(
            (value) => {
              setState(() {
                qrCodeDetails = LectureQRCodeDetails.fromJson(details);
                showQRCodeDetails = true;
              }),
            },
          );
        } else {
          CustomSnackBar.showError(context, "Scanned QR Code is not valid.");
        }
      } catch (e) {
        debugPrint(
          "The scanned QR code format is not supported by this app: $e",
        );
        CustomSnackBar.showError(
          context,
          "The scanned QR code format is not supported by this app.",
        );
      }
    } else {
      CustomSnackBar.showError(context, "Scanning canceled or failed.");
    }
  }

  Future<void> getModule(int moduleId) async {
    Module module = await ModuleService.getModuleByModuleCode(
      context,
      moduleId,
    );
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
                  left: screenWidth * 0.07,
                  right: screenWidth * 0.07,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: const Border(
                    top: BorderSide(color: Color(0xFF086494), width: 1.0),
                    bottom: BorderSide(color: Color(0xFF086494), width: 1.0),
                    left: BorderSide(color: Color(0xFF086494), width: 1.0),
                    right: BorderSide(color: Color(0xFF086494), width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage(
                          "lib/assets/qrcode/barcode-scanner.png",
                        ),
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
              if (isScanning)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: const Color(0xFF086494),
                          width: 2.0,
                        ),
                      ),
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.8,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: Color(0xFF086494),
                          borderRadius: 10,
                          borderLength: 30,
                          borderWidth: 10,
                          cutOutSize: screenWidth * 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await qrController?.stopCamera();
                        setState(() {
                          isScanning = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              if (showQRCodeDetails && qrCodeDetails != null)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        showScannedModule
                            ? Container(
                                width: screenWidth * 0.9,
                                child: ScannedModule(module: scannedModule!),
                              )
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
                                event: scannedEventQRCodeDetails!,
                              ),
                            ),
                          ],
                        ),
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
