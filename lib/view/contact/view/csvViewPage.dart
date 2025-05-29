import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/contact/controller/contact_controller.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../api_repository/app_url.dart';
import '../../../routes/my_constant.dart';
import '../../../utils/image_constant.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/toolbarTitle.dart';
import '../model/contact_export_model.dart';

class CsvInAppDemo extends StatefulWidget {
  @override
  _CsvInAppDemoState createState() => _CsvInAppDemoState();
}

class _CsvInAppDemoState extends State<CsvInAppDemo> {
  String csvPath = '';
  List<List<dynamic>> _csvData = [];
  ContactController contactController = Get.find();
  @override
  void initState() {
    super.initState();
    generateCsvFile(false);
  }

  void generateCsvFile(isOpenFile) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    for (var data
        in contactController.exportContactList[0].body?.headers ?? []) {
      row.add(data);
    }
    rows.add(row);
    for (int i = 0;
        i < contactController.exportContactList[0].body!.contacts!.length;
        i++) {
      ExportContacts contacts =
          contactController.exportContactList[0].body!.contacts![i];
      List<dynamic> row = [];
      row.add(contacts.name ?? "");
      row.add(contacts.email ?? "");
      row.add(contacts.country ?? "");
      row.add(contacts.mobile ?? "");
      row.add(contacts.company ?? "");
      row.add(contacts.position ?? "");
      row.add(contacts.note ?? "");
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();

    if (directory?.path != null) {
      File file = File("${directory!.path}/${AppUrl.appName} Contact.csv");
      // Write CSV data to file
      await file.writeAsString(csv);
      // Read the CSV file and parse it
      final input = await file.readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);
      setState(() {
        _csvData = csvTable;
        csvPath = file.path;
      });
      /*if (f.path != null) {
        try {
          var exception = OpenFile.open(f.path);
        } catch (e) {
          print('exception-:$e');
        }
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        height: 72.v,
        leadingWidth: 45.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(
            left: 7.h,
            top: 3,
            // bottom: 12.v,
          ),
          onTap: () {
            Get.back();
          },
        ),
        title: ToolbarTitle(title: "contact_csv_format".tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          contactController.generateCsvFile();
        },
        label: const Text("Open File"),
      ),
      body: csvPath.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: _csvData.isNotEmpty
                      ? _csvData[0]
                          .map((header) => DataColumn(
                                label: CustomTextView(
                                    text: header.toString(),
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold),
                              ))
                          .toList()
                      : [],
                  rows: _csvData.length > 1
                      ? _csvData
                          .skip(1)
                          .map(
                            (row) => DataRow(
                              cells: row
                                  .map((cell) => DataCell(CustomTextView(
                                        text: cell.toString(),
                                        fontWeight: FontWeight.normal,
                                      )))
                                  .toList(),
                            ),
                          )
                          .toList()
                      : [],
                ),
              ),
            ),
    );
  }
}
