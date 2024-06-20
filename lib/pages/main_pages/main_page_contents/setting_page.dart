import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/StudentUpdateSettingService.dart';

class SettingPage extends StatefulWidget {
  final String token;

  const SettingPage({Key? key, required this.token}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Map<String, dynamic> userDetails;
  late TextEditingController emailController;
  late TextEditingController semesterController;
  late TextEditingController roleController;
  late TextEditingController nameController;
  late TextEditingController indexController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  String userName = "";

  String? selectedDepartment; // Track selected department
  String? selectedSemester; // Track selected semester

  @override
  void initState() {
    super.initState();
    userDetails = JwtDecoder.decode(widget.token);
    userName = userDetails['studentUserName'];
    emailController = TextEditingController(text: userDetails['studentEmail']);
    semesterController = TextEditingController(text: userDetails['currentSemester'].toString());
    roleController = TextEditingController(text: userDetails['studentRole']);
    nameController = TextEditingController(text: userDetails['studentName']);
    indexController = TextEditingController(text: userDetails['indexNumber']);
    passwordController = TextEditingController(text: "");
    passwordConfirmController = TextEditingController(text: "");

    // Initialize selectedDepartment with the current department if not null
    selectedDepartment = userDetails['departmentId'] != null ? userDetails['departmentId'].toString() : null;

    // Initialize selectedSemester with the current semester if not null
    selectedSemester = userDetails['currentSemester'] != null ? userDetails['currentSemester'].toString() : null;
  }


  /*void _updateDetails() {
    setState(() {
      userDetails['studentEmail'] = emailController.text;
      userDetails['currentSemester'] = int.parse(selectedSemester!);
      userDetails['studentRole'] = roleController.text;
      userDetails['studentName'] = nameController.text;
      userDetails['departmentId'] = int.parse(selectedDepartment!);
      userDetails['indexNumber'] = indexController.text;
    });

    // Assuming StudentUpdateSettingService.updateStudent requires all these parameters
    StudentUpdateSettingService.updateStudent(
      context,
      userName,
      "", // Update password logic can be added here
      "", // Update confirm password logic can be added here
      nameController.text,
      indexController.text,
      emailController.text,
      roleController.text,
      int.parse(selectedDepartment!),
      int.parse(selectedSemester!),
    );

    print('Updated details: $userDetails');
  }*/

  List<Map<String, dynamic>> departmentList = [
    {"name": "DEIE", "id": 1},
    {"name": "DCOM", "id": 2},
    {"name": "DMME", "id": 3},
    {"name": "DCEE", "id": 4},
    {"name": "DMENA", "id": 5},
  ];

  List<Map<String, dynamic>> semesterList = [
    {"name": "1", "id": 1},
    {"name": "2", "id": 2},
    {"name": "3", "id": 3},
    {"name": "4", "id": 4},
    {"name": "5", "id": 5},
    {"name": "6", "id": 6},
    {"name": "7", "id": 7},
    {"name": "8", "id": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                'Profile Setting',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField("Name", nameController),
            _buildTextField("Email", emailController),
            _buildDropdownField(
              "Semester",
              semesterList,
              selectedSemester,
                  (newValue) {
                setState(() {
                  selectedSemester = newValue!['id'].toString();
                });
              },
            ),
            _buildDropdownField(
              "Department",
              departmentList,
              selectedDepartment,
                  (newValue) {
                setState(() {
                  selectedDepartment = newValue!['id'].toString();
                });
              },
            ),
            _buildTextField("Index Number", indexController),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: (){},
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      List<Map<String, dynamic>> options,
      String? value,
      ValueChanged<Map<String, dynamic>?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: DropdownButtonFormField<Map<String, dynamic>>(
        value: options.firstWhere((element) => element['id'].toString() == value),
        onChanged: onChanged,
        items: options.map((option) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: option,
            child: Text(option['name']),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
