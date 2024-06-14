import 'package:flutter/material.dart';

void showUnEnrollmentDialog(BuildContext context, Function() onUnEnroll) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("UnEnroll Module"),
        content: const Text("Are You Sure You Want To UnEnroll?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onUnEnroll();
              Navigator.of(context).pop();
            },
            child: Text("UnEnroll",style: TextStyle(color: Colors.red),),
          ),
        ],
      );
    },
  );
}
