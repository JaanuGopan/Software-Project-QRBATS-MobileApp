import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/modulecomponents/module_enrollement_item.dart';
import 'package:qrbats_sp/components/modulecomponents/module_unenrollment_item.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

import '../../../api_services/ModuleService.dart';

class ModulePage extends StatefulWidget {
  final String token;

  const ModulePage({super.key, required this.token});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late int studentId;
  List<Module> allModuleList = [];
  List<Module> allEnrolledModuleList = [];
  List<Module> notEnrolledModuleList = [];
  bool isAllModuleLoading = true;
  bool isAllEnrolledModuleLoading = true;
  String errorMessage = '';
  bool showEnrolledModule = true;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["userId"];
    _fetchAllModuleData(context, studentId);
    _fetchAllEnrolledModuleData(context, studentId);
  }

  Future<void> _fetchAllModuleData(BuildContext context, int studentId) async {
    try {
      final List<Module> modulesList =
          await ModuleService.getAllModule(context, studentId);
      setState(() {
        allModuleList = modulesList;
        _calculateNotEnrolledModules();
        isAllModuleLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load modules';
        isAllModuleLoading = false;
      });
    }
  }

  Future<void> _fetchAllEnrolledModuleData(
      BuildContext context, int studentId) async {
    try {
      final List<Module> modulesList =
          await ModuleService.getAllEnrolledModule(context, studentId);
      setState(() {
        allEnrolledModuleList = modulesList;
        _calculateNotEnrolledModules();
        isAllEnrolledModuleLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load enrolled modules';
        isAllEnrolledModuleLoading = false;
      });
    }
  }

  void _calculateNotEnrolledModules() {
    if (true) {
      final enrolledModuleIds =
          allEnrolledModuleList.map((module) => module.moduleId).toSet();
      notEnrolledModuleList = allModuleList
          .where((module) => !enrolledModuleIds.contains(module.moduleId))
          .toList();
    }
  }

  void _enrollModule(int moduleId, String enrollmentKey) async {
    if (enrollmentKey.isNotEmpty) {
      await ModuleService.moduleEnrollment(
          context, moduleId, studentId, enrollmentKey);
      _fetchAllEnrolledModuleData(
          context, studentId); // Refresh enrolled modules
      _fetchAllModuleData(context, studentId); // Refresh all modules
    }
  }

  void _unEnrollModule(int moduleId) async {
    await ModuleService.moduleUnEnrollment(context, moduleId, studentId);
    _fetchAllEnrolledModuleData(context, studentId); // Refresh enrolled modules
    _fetchAllModuleData(context, studentId); // Refresh all modules
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
                  child: isAllModuleLoading || isAllEnrolledModuleLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage.isNotEmpty
                          ? Center(child: Text(errorMessage))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ToggleButtons(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text('Enrolled Module'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text('Not Entrolled Module'),
                                      ),
                                    ],
                                    isSelected: [
                                      showEnrolledModule,
                                      !showEnrolledModule
                                    ],
                                    onPressed: (int index) {
                                      setState(() {
                                        showEnrolledModule = index == 0;
                                      });
                                    },
                                    color: Colors.black,
                                    selectedColor: Colors.white,
                                    fillColor: showEnrolledModule
                                        ? Color(0xFF086494)
                                        : Color(0xFF086494),
                                    selectedBorderColor: showEnrolledModule
                                        ? Color(0xFF086494)
                                        : Color(0xFF086494),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                SizedBox(height: 20),
                                const SizedBox(height: 10),
                                if (allEnrolledModuleList.isNotEmpty &&
                                    showEnrolledModule)
                                  _buildEnrolledModuleList(),
                                if (allEnrolledModuleList.isEmpty)
                                  const Center(
                                    child: Text("No Enrolled Modules."),
                                  ),
                                const SizedBox(height: 10),
                                if (notEnrolledModuleList.isNotEmpty &&
                                    !showEnrolledModule)
                                  _buildNotEnrolledModuleList(),
                                if (notEnrolledModuleList.isEmpty)
                                  const Center(
                                    child: Text("No Modules For Enrollment."),
                                  ),
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
      physics: NeverScrollableScrollPhysics(),
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
      physics: NeverScrollableScrollPhysics(),
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
