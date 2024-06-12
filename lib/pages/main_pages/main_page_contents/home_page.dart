import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

class Home extends StatefulWidget {
  final String token;

  const Home({Key? key, this.token = ""}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int studentId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    _fetchEnrolledModuleData(context, studentId);
  }

  List<EnrolledModule> moduleList = [];

  Future<void> _fetchEnrolledModuleData(
      BuildContext context, int studentId) async {
    final List<EnrolledModule> enrolledModuleList =
    await ModuleService.getAllEnrolledModule(context, studentId);
    setState(() {
      moduleList = enrolledModuleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            const Center(
                child: Text(
                  "Enrolled Modules",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  height: screenHeight * 0.7,
                  width: screenWidth * 0.9,
                  decoration: _buildContainerDecoration(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('No', style: TextStyle(fontSize: 10))),
                            DataColumn(
                                label: Text('Module Name',
                                    style: TextStyle(fontSize: 10))),
                            DataColumn(
                                label: Text('ModuleCode',
                                    style: TextStyle(fontSize: 10))),
                            DataColumn(
                                label: Text('View', style: TextStyle(fontSize: 10))),
                          ],
                          rows: moduleList.map((module) {
                            return DataRow(cells: [
                              DataCell(Text('${moduleList.indexOf(module) + 1}',
                                  style: const TextStyle(fontSize: 10))),
                              DataCell(Text(module.moduleName,
                                  style: const TextStyle(fontSize: 10))),
                              DataCell(Text(module.moduleCode,
                                  style: const TextStyle(fontSize: 10))),
                              DataCell(IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                onPressed: () {
                                  // Define the action to perform when the button is pressed
                                  _viewModuleDetails(module);
                                },
                              )),
                            ]);
                          }).toList()))),
            )
          ],
        ),
      ),
    );
  }

  void _viewModuleDetails(EnrolledModule module) {
    // Navigate to module details or perform any desired action
    print('Viewing details for module: ${module.moduleName}');
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border(
        top: BorderSide(
          color: Color(0xFF086494),
          width: 6.0,
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
    );
  }
}
