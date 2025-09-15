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
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(8, 100, 148, 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: showQRCodeDetails || showEventQrCodeDetails
                        ? Text(
                            "To mark your attendance, click the Attend button in the details section. Location access is required to complete attendance; if location access is not enabled, attendance cannot be recorded. If you encounter any issues, please try again.",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.justify,
                          )
                        : Text(
                            "Click the Scan QR Code button to scan a QR code using your camera. After scanning, you can view lecture or event details and mark your attendance. If camera or location access is denied, please enable them in your device settings.",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.all(8.0),
                child: isScanning
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: const AssetImage(
                                    "lib/assets/qrcode/barcode-scanner.png",
                                  ),
                                  height: screenWidth * 0.8,
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      height: screenWidth * 0.7,
                                      width: screenWidth * 0.7,
                                      child: QRView(
                                        key: qrKey,
                                        onQRViewCreated: _onQRViewCreated,
                                        overlay: QrScannerOverlayShape(
                                          borderColor: Color(0xFF086494),
                                          borderRadius: 10,
                                          borderLength: 30,
                                          borderWidth: 10,
                                          cutOutSize: screenWidth * 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: screenWidth * 0.7,
                                    width: screenWidth * 0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: Color(0xFF086494),
                                        width: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
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
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: const AssetImage(
                                "lib/assets/qrcode/barcode-scanner.png",
                              ),
                              height: screenWidth * 0.8,
                            ),
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
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
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
