import 'package:dreamcast/utils/dialog_constant.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:dreamcast/view/travelDesk/controller/travelSaveFormController.dart';
import 'package:dreamcast/view/travelDesk/model/flightFieldModule.dart';
import 'package:dreamcast/widgets/app_bar/appbar_leading_image.dart';
import 'package:dreamcast/widgets/app_bar/custom_app_bar.dart';
import 'package:dreamcast/widgets/button/common_material_button.dart';
import 'package:dreamcast/widgets/textview/customTextView.dart';
import 'package:dreamcast/widgets/toolbarTitle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TravelSaveFormPage extends GetView<TravelSaveFormController> {
  TravelSaveFormPage({Key? key}) : super(key: key);
  static const routeName = "/GetFormFieldPage";

  AuthenticationManager authenticationManager = Get.find();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.showSearchArrivalResults.value ||
            controller.showSearchDepartureResults.value) {
          controller.toggleArrivalSearch(false);
          controller.toggleDepartureSearch(false);
        }
      },
      child: Scaffold(
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
          title: ToolbarTitle(
              title: controller.type == MyConstant.flightArrival ||
                      controller.type == MyConstant.flightDeparture
                  ? "travelDesk".tr
                  : controller.type == MyConstant.visa
                      ? "visa".tr
                      : "passport".tr ?? ""),
        ),
        body: GetX<TravelSaveFormController>(builder: (controller) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.v),
            margin: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: colorLightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 21.h, right: 21.h, top: 5.v, bottom: 5.v),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text: controller.type == MyConstant.flightArrival
                        ? "arrivalDetails".tr
                        : controller.type == MyConstant.flightDeparture
                            ? "departureDetails".tr
                            : controller.type == MyConstant.visa
                                ? "visaDetails".tr
                                : "passportDetails".tr ?? "",
                    fontSize: 18,
                    maxLines: 10,
                    color: colorPrimary,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              UiHelper.commonDivider(),
              Expanded(
                child: Skeletonizer(
                  enabled: controller.loader.value,
                  child: ListView.builder(
                    padding:
                        EdgeInsets.only(top: 10.v, right: 16.h, left: 16.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.loader.value
                        ? 5
                        : controller.formFieldData.length,
                    itemBuilder: (context, index) {
                      if (controller.loader.value) {
                        return _buildDateTimePickerField(
                            context,
                            FlightFields(
                                name: "hello", label: "hello", type: ""));
                      }
                      var field = controller.formFieldData[index];
                      Future.delayed(const Duration(seconds: 1), () {
                        // controller.isValidateForm();
                      });
                      switch (field.type) {
                        case MyConstant.input:
                          return field.label == MyConstant.travellingFrom
                              ? _buildFlightArrivalWidget(context, field)
                              : field.label == MyConstant.travellingTo
                                  ? _buildFlightDepartureWidget(context, field)
                                  : _buildTextareaWidget(
                                      context, field, index.toString(),
                                      minLines: 1, maxLine: 1);
                        case MyConstant.datetimeLocal:
                          return _buildDateTimePickerField(context, field);
                        case MyConstant.date:
                          return _buildDateTimePickerField(context, field);
                        case MyConstant.file:
                          return _buildDateTimePickerField(context, field);
                        default:
                          return const Text("");
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: CommonMaterialButton(
                    color: colorPrimary,
                    isLoading: controller.buttonLoading.value,
                    text: "Save Details",
                    onPressed: () {
                      controller.callSaveFormApi();
                    }),
              )
            ]),
          );
        }),
      ),
    );
  }

  Widget _buildTextareaWidget(
      BuildContext context, FlightFields createFieldBody, String questionNumber,
      {required int minLines, required int maxLine}) {
    final TextEditingController textAreaController = TextEditingController();
    textAreaController.text = createFieldBody.value.toString();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        readOnly: createFieldBody.label == MyConstant.travellingFrom ||
                createFieldBody.label == MyConstant.travellingTo
            ? true
            : false,
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        enabled: !(createFieldBody.readonly ?? false),
        // maxLength: getMaxLength(),
        // keyboardType: getKeyboardType(),
        style: TextStyle(
            fontSize: 15.fSize,
            color: colorSecondary,
            fontWeight: FontWeight.normal),
        // validator: validator,
        onChanged: (value) {
          createFieldBody.value = value.isNotEmpty ? value : '';
        },
        decoration: InputDecoration(
          counter: const Offstage(),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: getLabelText(createFieldBody),
          hintText: createFieldBody.placeholder ?? "",
          hintStyle: TextStyle(
              fontSize: 15.fSize,
              color: colorGray,
              fontWeight: FontWeight.normal),
          labelStyle: TextStyle(
              fontSize: 15.fSize,
              color: colorGray,
              fontWeight: FontWeight.normal),
          fillColor:
              createFieldBody.readonly == true ? colorLightGray : Colors.white,
          filled: true,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
        ),
      ),
    );
  }

  Widget _buildFlightArrivalWidget(
      BuildContext context, FlightFields createFieldBody) {
    if (createFieldBody.value != null && createFieldBody.value != "") {
      controller.searchControllerArrival.text =
          createFieldBody.value.toString().replaceAll(" / ", " ") ?? "";
    }
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                controller: controller.searchControllerArrival,
                onTap: () {
                  controller.toggleArrivalSearch(true);
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.showSearchArrivalResults(true);
                    controller.filterSearch(value);
                    createFieldBody.value = value;
                    if (controller.filteredItems.isEmpty) {
                      controller.showSearchArrivalResults(false);
                    }
                  } else {
                    controller.toggleArrivalSearch(false);
                  }
                },
                style: TextStyle(
                    fontSize: 15.fSize,
                    color: colorSecondary,
                    fontWeight: FontWeight.normal),
                onEditingComplete: () {
                  controller.toggleArrivalSearch(false);
                },
                onFieldSubmitted: (value) {
                  controller.toggleArrivalSearch(false);
                },
                decoration: InputDecoration(
                  counter: const Offstage(),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: getLabelText(createFieldBody),
                  hintText: createFieldBody.placeholder ?? "",
                  hintStyle: TextStyle(
                      fontSize: 15.fSize,
                      color: colorGray,
                      fontWeight: FontWeight.normal),
                  labelStyle: TextStyle(
                      fontSize: 15.fSize,
                      color: colorGray,
                      fontWeight: FontWeight.normal),
                  fillColor: createFieldBody.readonly == true
                      ? colorLightGray
                      : Colors.white,
                  filled: true,
                  // suffixIcon: IconButton(onPressed: (){
                  //   controller.toggleSearch(controller.showSearchResults.value?false:true);
                  // }, icon: controller.showSearchResults.value
                  //     ? const Icon( Icons.arrow_drop_up, color: colorSecondary)
                  //     : const Icon( Icons.arrow_drop_down_outlined, color: colorSecondary),),
                  prefixIconConstraints: const BoxConstraints(minWidth: 60),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                ),
              ),
            ),
            controller.showSearchArrivalResults.value
                ? Container(
                    constraints: BoxConstraints(maxHeight: 250.v),
                    padding: EdgeInsets.all(5.adaptSize),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GetX<TravelSaveFormController>(
                      builder: (controller) {
                        final items = controller.filteredItems;
                        final itemCount = items.length;
                        final itemHeight = 72.0.v;
                        final double calculatedHeight =
                            (itemHeight * itemCount).clamp(0, 250.0);

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: calculatedHeight,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                title: CustomTextView(
                                  text: item.name ?? "",
                                  color: colorSecondary,
                                ),
                                subtitle: CustomTextView(
                                  text: "${item.city} • ${item.code}",
                                  fontWeight: FontWeight.w500,
                                  color: colorGray,
                                ),
                                onTap: () {
                                  controller
                                      .selectArrivalAirport(item.name ?? "");
                                  createFieldBody.value =
                                      "${item.city} / ${item.name} / ${item.code}";
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ))
                : const SizedBox.shrink()
          ],
        ));
  }

  Widget _buildFlightDepartureWidget(
      BuildContext context, FlightFields createFieldBody) {
    if (createFieldBody.value != null && createFieldBody.value != "") {
      controller.searchControllerDeparture.text =
          createFieldBody.value.toString().replaceAll(" / ", " ") ?? "";
    }
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                controller: controller.searchControllerDeparture,
                onTap: () {
                  controller.toggleDepartureSearch(true);
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.showSearchDepartureResults(true);
                    controller.filterSearch(value);
                    createFieldBody.value = value;
                    if (controller.filteredItems.isEmpty) {
                      controller.showSearchDepartureResults(false);
                    }
                  } else {
                    controller.toggleDepartureSearch(false);
                  }
                },
                style: TextStyle(
                    fontSize: 15.fSize,
                    color: colorSecondary,
                    fontWeight: FontWeight.normal),
                onEditingComplete: () {
                  controller.toggleDepartureSearch(false);
                },
                onFieldSubmitted: (value) {
                  controller.toggleDepartureSearch(false);
                },
                decoration: InputDecoration(
                  counter: const Offstage(),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  labelText: getLabelText(createFieldBody),
                  hintText: createFieldBody.placeholder ?? "",
                  hintStyle: TextStyle(
                      fontSize: 15.fSize,
                      color: colorGray,
                      fontWeight: FontWeight.normal),
                  labelStyle: TextStyle(
                      fontSize: 15.fSize,
                      color: colorGray,
                      fontWeight: FontWeight.normal),
                  fillColor: createFieldBody.readonly == true
                      ? colorLightGray
                      : Colors.white,
                  filled: true,
                  prefixIconConstraints: const BoxConstraints(minWidth: 60),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorLightGray),
                  ),
                ),
              ),
            ),
            controller.showSearchDepartureResults.value
                ? Container(
                    constraints: BoxConstraints(maxHeight: 250.v),
                    padding: EdgeInsets.all(5.adaptSize),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GetX<TravelSaveFormController>(
                      builder: (controller) {
                        final items = controller.filteredItems;
                        final itemCount = items.length;
                        final itemHeight = 72.0.v;
                        final double calculatedHeight =
                            (itemHeight * itemCount).clamp(0, 250.0);

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: calculatedHeight,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                title: CustomTextView(
                                  text: item.name ?? "",
                                  color: colorSecondary,
                                ),
                                subtitle: CustomTextView(
                                  text: "${item.city} • ${item.code}",
                                  fontWeight: FontWeight.w500,
                                  color: colorGray,
                                ),
                                onTap: () {
                                  controller
                                      .selectDepartureAirport(item.name ?? "");
                                  createFieldBody.value =
                                      "${item.city} / ${item.name} / ${item.code}";
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ))
                : const SizedBox.shrink()
          ],
        ));
  }

  String getLabelText(
    FlightFields createFieldBody,
  ) {
    return '${createFieldBody.label} ${createFieldBody.rules.toString().contains("required") ? "*" : ""}';
  }

  Widget _buildDateTimePickerField(
      BuildContext context, FlightFields createFieldBody) {
    final TextEditingController textAreaController = TextEditingController();

    if (createFieldBody.value != null && createFieldBody.value != "") {
      textAreaController.text = createFieldBody.value.toString();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: textAreaController,
        enabled: !(createFieldBody.readonly ?? false),
        readOnly: true,
        onTap: () async {
          if (createFieldBody.type == MyConstant.datetimeLocal ||
              createFieldBody.type == MyConstant.date) {
            _selectDateTime(context, createFieldBody, textAreaController);
          } else if (createFieldBody.type == MyConstant.file) {
            showPickerBottomSheet(context, createFieldBody, textAreaController);
          }
        },
        style: TextStyle(
            fontSize: 15.fSize,
            color: colorSecondary,
            fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          suffixIcon: createFieldBody.type == MyConstant.datetimeLocal ||
                  createFieldBody.type == MyConstant.date
              ? IconButton(
                  onPressed: null,
                  icon: SvgPicture.asset(ImageConstant.calendar_icon,
                      color: colorSecondary, height: 20))
              : createFieldBody.type == MyConstant.file
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          showPickerBottomSheet(
                              context, createFieldBody, textAreaController);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.h, vertical: 10.v),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                              color: Colors.grey), // Light border
                          backgroundColor:
                              Colors.grey.shade100, // Light background
                        ),
                        child: CustomTextView(
                          text: "Upload",
                          color: colorSecondary,
                          fontSize: 15.fSize,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
          counter: const Offstage(),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: getLabelText(createFieldBody),
          hintText: createFieldBody.placeholder ?? "",
          hintStyle: TextStyle(
              fontSize: 15.fSize,
              color: colorGray,
              fontWeight: FontWeight.normal),
          labelStyle: TextStyle(
              fontSize: 15.fSize,
              color: colorGray,
              fontWeight: FontWeight.normal),
          fillColor:
              createFieldBody.readonly == true ? colorLightGray : Colors.white,
          filled: true,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorLightGray),
          ),
        ),
      ),
    );
  }

  ///common widget
  Widget sharedContainer(Widget child, {EdgeInsets? margin}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: margin ?? const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Future<void> _selectDateTime(
      BuildContext context,
      FlightFields createFieldBody,
      final TextEditingController textAreaController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (createFieldBody.type == MyConstant.datetimeLocal) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          String formattedDateTime =
              DateFormat("yyyy-MM-dd | hh:mm a").format(finalDateTime);
          createFieldBody.value = formattedDateTime;
          textAreaController.text =
              DateFormat("dd MMM, yyyy | hh:mm a").format(finalDateTime);
        }
      } else if (createFieldBody.type == MyConstant.date) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        createFieldBody.value = formattedDate;
        textAreaController.text = DateFormat("dd MMM, yyyy").format(pickedDate);
      }
    }
  }

  void showPickerBottomSheet(BuildContext context, FlightFields createFieldBody,
      final TextEditingController textAreaController) {
    showModalBottomSheet(
        context: context,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const CustomTextView(
                    text: 'Pick Image',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    String fileName = await pickImage(createFieldBody);
                    if (fileName.isNotEmpty) {
                      textAreaController.text = fileName;
                      print('Image picked: $fileName');
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const CustomTextView(
                    text: 'Pick PDF',
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    String fileName = await pickPDF(createFieldBody);
                    if (fileName.isNotEmpty) {
                      textAreaController.text = fileName;
                      // Optionally show success or update UI
                      print('PDF picked: $fileName');
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<String> pickPDF(FlightFields createFieldBody) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      controller.pdfPath.text = result.files.single.path!;
      createFieldBody.value = result.files.single.path ?? "";
      return path.basename(result.files.single.path!);
    } else {
      return "";
    }
  }

  Future<String> pickImage(FlightFields createFieldBody) async {
    // Check current camera permission status
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      // If permission is denied or permanently denied
      DialogConstantHelper.showPermissionDialog();
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "cropper".tr,
              toolbarColor: colorSecondary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true),
          IOSUiSettings(
              title: 'Cropper',
              aspectRatioLockEnabled: true, // Lock aspect ratio
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
              ],
              hidesNavigationBar: true),
        ],
      );
      if (croppedFile != null) {
        final filePath = croppedFile.path;
        controller.pdfPath.text = filePath;
        createFieldBody.value = filePath;
        return path.basename(filePath);
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}
