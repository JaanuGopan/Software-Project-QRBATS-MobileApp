import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/modulecomponents/module_enrolled_item.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';

class Home extends StatefulWidget {
  final String token;

  const Home({Key? key, this.token = ""}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int studentId;
  List<Module> moduleList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    _fetchEnrolledModuleData(context, studentId);
  }

  Future<void> _fetchEnrolledModuleData(
      BuildContext context, int studentId) async {
    try {
      final List<Module> enrolledModuleList =
          await ModuleService.getAllEnrolledModule(context, studentId);
      setState(() {
        moduleList = enrolledModuleList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load modules';
        isLoading = false;
      });
    }
  }

  void _unEnrollModule(int moduleId) async {
    if (moduleId.isFinite) {
      await ModuleService.moduleUnEnrollment(context, moduleId, studentId);
      _fetchEnrolledModuleData(
          context, studentId); // Refresh module list after enrollment
    }
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Container(
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.95,
                    padding: const EdgeInsets.all(9.0),
                    decoration: _buildContainerDecoration(),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage.isNotEmpty
                            ? Center(child: Text(errorMessage))
                            : ListView.builder(
                                itemCount: moduleList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (index == 0)
                                        const Text(
                                          "Enrolled Modules",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      if (index == 0)
                                        const SizedBox(height: 10),
                                      ModuleEnrolledContent(
                                        module: moduleList[index],
                                        number: index + 1,
                                      ),
                                    ],
                                  );
                                },
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
