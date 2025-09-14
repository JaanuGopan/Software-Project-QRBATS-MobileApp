import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/MerkAttendanceService.dart';
import 'package:qrbats_sp/components/mark_attendance/MarkEventAttendancePopup.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:qrbats_sp/utils/LocationUtils.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class ScannedEvent extends StatefulWidget {
  final EventQRCodeDetails event;

  const ScannedEvent({
    super.key,
    required this.event,
  });

  @override
  State<ScannedEvent> createState() => _ScannedEventState();
}

class _ScannedEventState extends State<ScannedEvent> {
  bool isProcessing = false; // Add this state variable

  @override
  void initState() {
    super.initState();
  }

  void _handleMarkAttendance() async {
    setState(() {
      isProcessing = true;
    });
    try {
      bool isPermissionGranted = await LocationUtils.checkPermissions();
      if (isPermissionGranted) {
        await LocationUtils.getLocation().then((position) async {
          await markEventAttendance(widget.event.eventId, position.latitude,
                  position.longitude, context)
              .then((value) {
            if (value) {
              CustomSnackBar.showSuccess(
                  context, 'Successfully marked attendance');
            }
          });
        }).catchError((error) {
          debugPrint('Error getting location: $error');
          CustomSnackBar.showError(context, 'Error in getting location.');
        });
      } else {
        CustomSnackBar.showError(
            context, 'Location permission is required to mark attendance.');
      }
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<bool> markEventAttendance(int eventId, double latitude,
      double longitude, BuildContext context) async {
    bool isCloseDetails = await MarkAttendanceService.markAttendance(
        eventId, latitude, longitude, context);
    return isCloseDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
                const SizedBox(width: 10),
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
                            const SizedBox(height: 4),
                            Text(
                              "Date : ${widget.event.eventDate}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Time : ${widget.event.eventTime}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Venue : ${widget.event.eventVenue}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                isProcessing
                    ? const CircularProgressIndicator(
                        color: Color(0xFF086494),
                      ) // Show CircularProgressIndicator if processing
                    : ElevatedButton(
                        onPressed: () => markEventAttendancePopup(context,
                            () => _handleMarkAttendance(), widget.event),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Attend",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
