import 'package:flutter/material.dart';
import 'package:skyticker/api/service/ModuleService.dart';
import 'package:skyticker/components/modulecomponents/module_enrolled_item.dart';
import 'package:skyticker/models/EnrolledModule.dart';

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
            ModuleEnrolledContent(module: moduleList[index], number: index + 1),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
