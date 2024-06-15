import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../components/texts/TextBlue.dart';

class SettingPage extends StatefulWidget {
  final String token;
  const SettingPage({super.key, this.token = ""});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Map<String, dynamic> userDetails;
  late TextEditingController emailController;
  late TextEditingController semesterController;
  late TextEditingController roleController;
  late TextEditingController nameController;
  late TextEditingController departmentController;
  late TextEditingController indexController;

  @override
  void initState() {
    super.initState();
    //userDetails = Jwt.parseJwt(widget.token);
    Map<String, dynamic> userDetails = JwtDecoder.decode(widget.token);
    emailController = TextEditingController(text: userDetails['studentEmail']);
    semesterController = TextEditingController(text: userDetails['currentSemester'].toString());
    roleController = TextEditingController(text: userDetails['studentRole']);
    nameController = TextEditingController(text: userDetails['studentName']);
    departmentController = TextEditingController(text: userDetails['departmentId'].toString());
    indexController = TextEditingController(text: userDetails['indexNumber']);
  }

  void _updateDetails() {
    setState(() {
      userDetails['studentEmail'] = emailController.text;
      userDetails['currentSemester'] = int.parse(semesterController.text);
      userDetails['studentRole'] = roleController.text;
      userDetails['studentName'] = nameController.text;
      userDetails['departmentId'] = int.parse(departmentController.text);
      userDetails['indexNumber'] = indexController.text;
    });
    // Here, you would send the updated details to your backend server.
    // For demonstration, we'll simply print the updated details.
    print('Updated details: $userDetails');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(child: Text("Profile Setting", style: TextStyle(fontSize: 18),),),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: screenHeight * 0.75,
                  width: screenWidth * 0.9,
                  decoration: _buildContainerDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildTextField("Email", emailController),
                        _buildTextField("Semester", semesterController),
                        _buildTextField("Role", roleController),
                        _buildTextField("Name", nameController),
                        _buildTextField("Department ID", departmentController),
                        _buildTextField("Index Number", indexController),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateDetails,
                          child: Text("Update"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.grey,
        width: 0,
      ),
    );
  }
}
