import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrbats_sp/api_services/MerkAttendanceService.dart';
import 'package:intl/intl.dart';
import 'package:qrbats_sp/components/mark_attendance/MarkEventAttendancePopup.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class ScannedEvent extends StatefulWidget {
  final EventQRCodeDetails event;
  final int studentId;

  const ScannedEvent({
    super.key,
    required this.event,
    required this.studentId,
  });

  @override
  State<ScannedEvent> createState() => _ScannedEventState();
}

class _ScannedEventState extends State<ScannedEvent> {
  bool isProcessing = false; // Add this state variable

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CustomSnackBar.showError(context, 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomSnackBar.showError(context, 'Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        CustomSnackBar.showError(
            context, 'Location permission permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(
            seconds: 10), // Add a timeout to avoid waiting indefinitely
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
    } catch (e) {
      CustomSnackBar.showError(context, 'Failed to get location: $e');
    }
  }

  Future<void> checkLocationPermission() async {
    await getLocation();
  }

  void _handleMarkAttendance() async {
    setState(() {
      isProcessing = true;
    });
    try {
      await checkLocationPermission();
      await markEventAttendance(
          widget.event.eventId, widget.studentId, latitude, longitude, context);
    } catch (e) {
      CustomSnackBar.showError(context, 'Failed to mark attendance: $e');
    } finally {
      setState(() {
        isProcessing = false; // Set isProcessing to false when done
      });
    }
  }

  Future<void> markEventAttendance(int eventId, int studentId, double latitude,
      double longitude, BuildContext context) async {
    try {
      bool isCloseDetails = await MarkAttendanceService.markAttendance(
          eventId, studentId, latitude, longitude, context);
      if (isCloseDetails) {
        setState(() {
          // Refresh the state if necessary
        });
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'Failed to mark attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm a');
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Event Name : ${widget.event.eventName}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Date : ${widget.event.eventDate}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Time : ${widget.event.eventTime}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Venue : ${widget.event.eventVenue}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                isProcessing
                    ? CircularProgressIndicator() // Show CircularProgressIndicator if processing
                    : OutlinedButton(
                        onPressed: () => markEventAttendancePopup(context,
                            () => _handleMarkAttendance(), widget.event),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Attend",
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
