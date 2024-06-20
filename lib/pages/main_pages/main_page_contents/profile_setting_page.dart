import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/StudentUpdateSettingService.dart';
import 'package:qrbats_sp/components/profile_update/profile_update_popup.dart';

class ProfileSettingPage extends StatefulWidget {
  final String token;

  const ProfileSettingPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  late TextEditingController emailController;
  late TextEditingController semesterController;
  late TextEditingController roleController;
  late TextEditingController nameController;
  late TextEditingController indexController;
  String userName = "";

  String? selectedDepartment; // Track selected department
  String? selectedSemester; // Track selected semester

  int? studentId;
  @override
  void initState() {
    super.initState();
    // Mock userDetails for demonstration (replace with actual logic to decode JWT)
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    emailController = TextEditingController(text: jwtDecodedToken["studentEmail"]);
    semesterController = TextEditingController(text: jwtDecodedToken["currentSemester"].toString());
    roleController = TextEditingController(text: jwtDecodedToken["studentRole"].toString());
    nameController = TextEditingController(text: jwtDecodedToken["studentName"]);
    indexController = TextEditingController(text: jwtDecodedToken["indexNumber"]);
    selectedDepartment = jwtDecodedToken["departmentId"].toString(); // Mocked department ID
    selectedSemester = jwtDecodedToken["currentSemester"].toString(); // Mocked semester ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text("Profile Setting",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            _buildTextField("Name", nameController),
            _buildTextField("Email", emailController),
            _buildDropdownField("Semester", _getSemesterList(), selectedSemester, (newValue) {
              setState(() {
                selectedSemester = newValue;
              });
            }),
            _buildDropdownField("Department", _getDepartmentList(), selectedDepartment, (newValue) {
              setState(() {
                selectedDepartment = newValue;
              });
            }),
            _buildTextField("Index Number", indexController),
            SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {
                  showUpdateProfile(context, ()=>_updateDetails());
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF086494)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Update Profile",
                  style: TextStyle(color: Color(0xFF086494)),
                )),
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
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      List<Map<String, dynamic>> items,
      String? value,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['id'].toString(),
            child: Text(item['name']),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
  List departmentList = ["DEIE","DCOM","DMME","DCEE","DMENA"];
  List<Map<String, dynamic>> _getDepartmentList() {
    return [
      {"name": "DEIE", "id": "1"},
      {"name": "DCOM", "id": "2"},
      {"name": "DMME", "id": "3"},
      {"name": "DCEE", "id": "4"},
      {"name": "DMENA", "id": "5"},
    ];
  }


  List<Map<String, dynamic>> _getSemesterList() {
    return [
      {"name": "1", "id": "1"},
      {"name": "2", "id": "2"},
      {"name": "3", "id": "3"},
      {"name": "4", "id": "4"},
      {"name": "5", "id": "5"},
      {"name": "6", "id": "6"},
      {"name": "7", "id": "7"},
      {"name": "8", "id": "8"},
    ];
  }




  void _updateDetails() async {
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;
    String updatedIndex = indexController.text;
    String updatedSemester = selectedSemester!;
    String updatedDepartment = selectedDepartment!;

    await StudentUpdateSettingService.updateStudent(context,studentId! ,"", "", "", updatedName, updatedIndex, updatedEmail, "", int.parse(updatedDepartment),int.parse(updatedSemester));
    // Replace with actual update logic using API service
    print('Updating details...');
    print('Name: $updatedName, Email: $updatedEmail, Index: $updatedIndex, Semester: $updatedSemester, Department: $updatedDepartment');
    // Call your update service here with the updated values
  }
}


