import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/components/modulecomponents/module_enrolled_item.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Module> moduleList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEnrolledModuleData(context);
  }

  Future<void> _fetchEnrolledModuleData(BuildContext context) async {
    try {
      final List<Module> enrolledModuleList =
          await ModuleService.getAllEnrolledModule(context);
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
      await ModuleService.moduleUnEnrollment(context, moduleId);
      _fetchEnrolledModuleData(
          context); // Refresh module list after unenrollment
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(9.0),
                  //decoration: _buildContainerDecoration(),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF086494),
                          ),
                        )
                      : errorMessage.isNotEmpty
                          ? Center(child: Text(errorMessage))
                          : moduleList.isEmpty
                              ? const Center(child: Text("No Enrolled Modules"))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Enrolled Modules",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildEnrolledModuleList(),
                                  ],
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnrolledModuleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: moduleList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ModuleEnrolledContent(
              module: moduleList[index],
              number: index + 1,
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Color(0xFF086494),
        width: 0.2,
      ),
    );
  }
}
