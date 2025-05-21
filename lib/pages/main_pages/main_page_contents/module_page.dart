import 'package:flutter/material.dart';
import 'package:qrbats_sp/components/modulecomponents/module_enrollement_item.dart';
import 'package:qrbats_sp/components/modulecomponents/module_unenrollment_item.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

import '../../../api_services/ModuleService.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  List<Module> allModuleList = [];
  List<Module> allEnrolledModuleList = [];
  List<Module> notEnrolledModuleList = [];
  bool isAllModuleLoading = true;
  bool isAllEnrolledModuleLoading = true;
  bool showEnrolledModule = true;

  @override
  void initState() {
    super.initState();
    _fetchAllModuleData();
    _fetchAllEnrolledModuleData();
  }

  Future<void> _fetchAllModuleData() async {
    setState(() {
      isAllModuleLoading = true;
    });
    try {
      final List<Module> modulesList =
          await ModuleService.getAllModule(context);
      setState(() {
        allModuleList = modulesList;
        notEnrolledModuleList = modulesList;
      });
    } finally {
      setState(() {
        isAllModuleLoading = false;
      });
    }
  }

  Future<void> _fetchAllEnrolledModuleData() async {
    setState(() {
      isAllEnrolledModuleLoading = true;
    });
    try {
      final List<Module> modulesList =
          await ModuleService.getAllEnrolledModule(context);
      setState(() {
        allEnrolledModuleList = modulesList;
        notEnrolledModuleList = modulesList;
      });
    } finally {
      setState(() {
        isAllEnrolledModuleLoading = false;
      });
    }
  }

  void _enrollModule(int moduleId, String enrollmentKey) async {
    if (enrollmentKey.isNotEmpty) {
      await ModuleService.moduleEnrollment(context, moduleId, enrollmentKey);
      await _fetchAllEnrolledModuleData(); // Refresh enrolled modules
      await _fetchAllModuleData(); // Refresh all modules
    }
  }

  void _unEnrollModule(int moduleId) async {
    await ModuleService.moduleUnEnrollment(context, moduleId);
    await _fetchAllEnrolledModuleData(); // Refresh enrolled modules
    await _fetchAllModuleData(); // Refresh all modules
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ToggleButtons(
                          isSelected: [showEnrolledModule, !showEnrolledModule],
                          onPressed: (int index) {
                            if (index == 1) {
                              _fetchAllModuleData();
                            }
                            if (index == 0) {
                              _fetchAllEnrolledModuleData();
                            }
                            setState(() {
                              showEnrolledModule = index == 0;
                            });
                          },
                          color: Colors.black,
                          selectedColor: Colors.white,
                          fillColor: showEnrolledModule
                              ? const Color(0xFF086494)
                              : const Color(0xFF086494),
                          selectedBorderColor: showEnrolledModule
                              ? const Color(0xFF086494)
                              : const Color(0xFF086494),
                          borderRadius: BorderRadius.circular(8.0),
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Enrolled Module'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Not Enrolled Module'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...(isAllModuleLoading || isAllEnrolledModuleLoading)
                          ? [
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF086494),
                                ),
                              )
                            ]
                          : [
                              if (showEnrolledModule) ...[
                                if (allEnrolledModuleList.isNotEmpty) ...[
                                  _buildEnrolledModuleList(),
                                ] else
                                  const Center(
                                    child: Text("No Enrolled Modules."),
                                  ),
                              ] else ...[
                                if (notEnrolledModuleList.isNotEmpty) ...[
                                  _buildNotEnrolledModuleList(),
                                ] else
                                  const Center(
                                    child: Text("No Modules For Enrollment."),
                                  ),
                              ]
                            ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnrolledModuleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allEnrolledModuleList.length,
      itemBuilder: (context, index) {
        return ModuleUnEnrollContent(
          module: allEnrolledModuleList[index],
          number: index + 1,
          onUnEnroll: _unEnrollModule,
        );
      },
    );
  }

  Widget _buildNotEnrolledModuleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notEnrolledModuleList.length,
      itemBuilder: (context, index) {
        return ModuleEnrollContent(
          module: notEnrolledModuleList[index],
          number: index + 1,
          onClick: _enrollModule,
        );
      },
    );
  }
}
