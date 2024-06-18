import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/components/modulecomponents/ModuleEnrolmentPopup.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

class ModuleEnrollContent extends StatelessWidget {
  final Module module;
  final int number;
  final Function(int moduleId, String enrollmentKey) onClick;

  const ModuleEnrollContent({
    super.key,
    required this.module,
    required this.number,
    required this.onClick,
  });

  double _getFontSize(double screenWidth, {bool isSubtext = false}) {
    if (screenWidth < 360) {
      return isSubtext ? 10 : 12;
    } else if (screenWidth < 720) {
      return isSubtext ? 12 : 14;
    } else {
      return isSubtext ? 14 : 16;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(width: 10),
          Text(
            number.toString(),
            style: TextStyle(fontSize: _getFontSize(screenWidth)),
          ),
          SizedBox(width: 40),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    module.moduleCode,
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    module.moduleName,
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth, isSubtext: true),
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => showEnrollmentDialog(
              context,
                  (key) => onClick(module.moduleId, key),
              module
            ),
            icon: Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
