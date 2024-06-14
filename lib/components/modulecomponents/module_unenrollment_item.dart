import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/components/modulecomponents/ModuleUnEnrolmentPopup.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

class ModuleUnEnrollContent extends StatelessWidget {
  final Module module;
  final int number;
  final Function(int moduleId) onUnEnroll;

  const ModuleUnEnrollContent({
    super.key,
    required this.module,
    required this.number,
    required this.onUnEnroll,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10,),
          Text(number.toString(), style: TextStyle(fontSize: 16)),
          SizedBox(width: 40,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(module.moduleCode, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(module.moduleName, style: TextStyle(fontSize: 14,color: Colors.grey)),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => showUnEnrollmentDialog(context, () => onUnEnroll(module.moduleId)),
            icon: Icon(Icons.delete_forever_outlined,color: Colors.red,),
          ),
        ],
      ),
    );
  }
}
